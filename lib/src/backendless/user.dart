part of hetima_mbaas_backendless;

class BackendlessUser {
  static final String REGIST_NAME = "name";
  static final String REGIST_PASSWORD = "password";
  static final String REGIST_EMAIL = "email";

  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessUser(this.builder, this.applicationId, this.secretKey) {}

  Future<LoginResult> login(String login, String password, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.backendless.com/${version}/users/login", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "application-type": "REST", //
          "Content-Type": "application/json" //
        }, //
        data: """{"login" : "${login}", "password" : "${password}"}""" //
        );
    return new LoginResult.fromResponse(resonse);
  }

  Future<RegistResult> regist(Map<String, String> properties, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.backendless.com/${version}/users/register", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "application-type": "REST", //
          "Content-Type": "application/json" //
        }, //
        data: JSON.encode(properties) //
        );
    return new RegistResult.fromResponse(resonse);
  }

  Future<LogoutResult> logout(String userToken, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/users/logout", //
        headers: {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "user-token": "${userToken}" //
    } //
        );
    return new LogoutResult.fromResponse(resonse);
  }

  Future<GetUserPropertyResult> getUserProperty(String objectId, List<String> props, {String version: "v1"}) async {
    StringBuffer propsBuffer = new StringBuffer("props=");
    for(int i=0;i<props.length;i++) {
      if(i!=0) {
        propsBuffer.write(",");
      }
      propsBuffer.write(props[i]);
    }

    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/users/${objectId}?${propsBuffer.toString()}", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "application-type": "REST"
        }
    );
    return new GetUserPropertyResult.fromResponse(resonse);
  }
}

class GetUserPropertyResult {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;

  GetUserPropertyResult.fromResponse(TinyNetRequesterResponse r) {
    String utf8binary = UTF8.decode(r.response.asUint8List());
    statusCode = r.status;
    if (r.status == 200) {
      isOk = true;
    } else {
      isOk = false;
    }

    try {
      keyValues = JSON.decode(utf8binary);
    } catch (e) {}

    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }

  }
}

class LogoutResult {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;

  LogoutResult.fromResponse(TinyNetRequesterResponse r) {
    String utf8binary = UTF8.decode(r.response.asUint8List());

    try {
      keyValues = JSON.decode(utf8binary);
    } catch (e) {}

    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }

    statusCode = r.status;

    if (r.status == 200) {
      isOk = true;
    } else {
      isOk = false;
    }
  }
}

class RegistResult {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  int statusCode = 0;
  Map keyValues = {};

  RegistResult.fromResponse(TinyNetRequesterResponse r) {
    String utf8binary = UTF8.decode(r.response.asUint8List());
    try {
      keyValues = JSON.decode(utf8binary);
    } catch (e) {}
    if (keyValues.containsKey("objectId")) {
      objectId = keyValues["objectId"];
    }
    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }
    statusCode = r.status;
    if (r.status == 200) {
      isOk = true;
    } else {
      isOk = false;
    }
  }
}

class LoginResult {
  bool isOk = false;
  String userToken = "";
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;

  LoginResult.fromResponse(TinyNetRequesterResponse r) {
    String utf8binary = UTF8.decode(r.response.asUint8List());

    try {
      keyValues = JSON.decode(utf8binary);
    } catch (e) {}

    if (keyValues.containsKey("user-token")) {
      userToken = keyValues["user-token"];
    }
    if (keyValues.containsKey("objectId")) {
      objectId = keyValues["objectId"];
    }
    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }

    statusCode = r.status;
    if (r.status == 200 && userToken != null && userToken.length != 0) {
      isOk = true;
    } else {
      isOk = false;
    }
  }
}
