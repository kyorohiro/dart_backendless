part of hetima_mbaas_parse;

class ParseUser {
  static final String REGIST_NAME = "username";
  static final String REGIST_PASSWORD = "password";
  static final String REGIST_EMAIL = "email";

  TinyNetBuilder builder;
  String applicationId;
  String secretKey;

  ParseUser(this.builder, this.applicationId, this.secretKey) {}

  Future signup(String username, String password,
    {Map<String, Object> properties: null, String revocableSession:"1", String version: "1"}) async {
    if (properties == null) {
      properties = {};
    }
    TinyNetRequester requester = await this.builder.createRequester();
    properties[REGIST_NAME] = username;
    properties[REGIST_PASSWORD] = password;

    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.parse.com/${version}/users", //
        headers: {
          "X-Parse-Application-Id": applicationId, //
          "X-Parse-REST-API-Key": secretKey, //
          "X-Parse-Revocable-Session": revocableSession, //
          "Content-Type": "application/json" //
        }, //
        data: JSON.encode(properties) //
        );
    return new SignUpUserResult.fromResponse(resonse);
  }

  Future<LoginUserResult> login(String username, String password,
    {String revocableSession:"1", String version: "1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();

    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        Uri.encodeFull("https://api.parse.com/${version}/login?username=${username}&password=${password}"), //
        headers: {
          "X-Parse-Application-Id": applicationId, //
          "X-Parse-REST-API-Key": secretKey, //
          "X-Parse-Revocable-Session": revocableSession, //
          "Content-Type": "application/json" //
        }
        );
    return new LoginUserResult.fromResponse(resonse);
  }

  Future<LogoutUserResult> logout(String seesionToken, {String version: "1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.parse.com/${version}/logout", //
        headers: {
          "X-Parse-Application-Id": applicationId, //
          "X-Parse-REST-API-Key": secretKey, //
          "X-Parse-Session-Token": seesionToken, //
        }
      );
    return new LogoutUserResult.fromResponse(resonse);
  }

  Future<DeleteUserResult> deleteUser(String objectId, String seesionToken, {String version: "1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_DELETE, //
        "https://api.parse.com/${version}/users/${objectId}", //
        headers: {
          "X-Parse-Application-Id": applicationId, //
          "X-Parse-REST-API-Key": secretKey, //
          "X-Parse-Session-Token": seesionToken, //
        }
      );
    return new DeleteUserResult.fromResponse(resonse);
  }
}

class LogoutUserResult extends ParseResultBase {
  LogoutUserResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class LoginUserResult extends ParseResultBase {
  String sessionToken="";
  LoginUserResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
    if(keyValues.containsKey("sessionToken")) {
      sessionToken = this.keyValues["sessionToken"];
    }
  }
}

class SignUpUserResult extends ParseResultBase {
  SignUpUserResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {}
}

class DeleteUserResult extends ParseResultBase {
  DeleteUserResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {}
}

class ParseResultBase {
  Map keyValues = {};
  String utf8binary = "";
  Uint8List binary = new Uint8List.fromList([]);

  //
  String error = "";
  int code = 9999;

  //
  int statusCode = 0;
  bool isOk = false;

  //
  String objectId = "";
  String updatedAt = "";
  String createdAt = "";
  String locationHeaderValue = "";

  ParseResultBase.fromResponse(TinyNetRequesterResponse r, {bool isJson: true}) {
    statusCode = r.status;
    isOk = ((r.status == 200 || r.status == 201) ? true : false);
    locationHeaderValue = r.headers["Location"];

    try {
      binary = new Uint8List.fromList(r.response.asUint8List());
      if (isJson == true || isOk == false) {
        utf8binary = UTF8.decode(r.response.asUint8List());
        if (utf8binary == null) {
          utf8binary = "";
        }
        var v = JSON.decode(utf8binary);
        if (v is Map) {
          keyValues = v;
        } else {
          print("--${v}");
        }
      }
    } catch (e) {}
    //
    //
    if (keyValues.containsKey("objectId")) {
      objectId = keyValues["objectId"];
    }
    if (keyValues.containsKey("createdAt")) {
      createdAt = keyValues["createdAt"];
    }
    if (keyValues.containsKey("updatedAt")) {
      updatedAt = keyValues["updatedAt"];
    }

    //
    //
    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("error")) {
      error = keyValues["error"];
    }
  }
}
