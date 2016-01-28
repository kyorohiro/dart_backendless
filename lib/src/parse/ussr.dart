part of hetima_mbaas_parse;

class ParseUser {
  static final String REGIST_NAME = "username";
  static final String REGIST_PASSWORD = "password";
  static final String REGIST_EMAIL = "email";
  /*
  curl -X POST \
    -H "X-Parse-Application-Id: TD5KN7BJnmG2SKSytS11lS5Ve7s4lMEIFcyXxVj6" \
    -H "X-Parse-REST-API-Key: WGtQFSnPMYoJLOownwg7HXnuoNWo78gdM8sS7wMZ" \
    -H "X-Parse-Revocable-Session: 1" \
    -H "Content-Type: application/json" \
    -d '{"username":"cooldude6","password":"p_n7!-e8","phone":"415-392-0202"}' \
    https://api.parse.com/1/users
    */
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;

  ParseUser(this.builder, this.applicationId, this.secretKey) {}

  Future regist(String username, String password, {Map<String, Object> properties: {}, String version: "1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    properties[REGIST_NAME] = username;
    properties[REGIST_PASSWORD] = password;

    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.parse.com/${version}/users", //
        headers: {
          "X-Parse-Application-Id": applicationId, //
          "X-Parse-REST-API-Key": secretKey, //
          "X-Parse-Revocable-Session": "1", //
          "Content-Type": "application/json" //
        }, //
        data: JSON.encode(properties) //
        );
    return null;
  }
}

class ParseResultBase {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;
  String utf8binary = "";
  Uint8List binary = new Uint8List.fromList([]);

  ParseResultBase.fromResponse(TinyNetRequesterResponse r, {bool isJson: true}) {
    statusCode = r.status;
    if (r.status == 200) {
      isOk = true;
    } else {
      isOk = false;
    }

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
    if (keyValues.containsKey("objectId")) {
      objectId = keyValues["objectId"];
    }
    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }
  }
}
