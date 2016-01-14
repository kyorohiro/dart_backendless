library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';

class Backendless {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  Backendless(this.builder, this.applicationId, this.secretKey) {}

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

  Future<SaveDataResult> saveData(String tableName, Map<String,Object> body, {String userToken:null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String,String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type": "application/json" //
    };
    if(userToken != null) {
      headers["user-token"] = userToken;
    }
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.backendless.com/${version}/data/${tableName}", //
        headers: headers, //
        data: JSON.encode(body));
    
    return new SaveDataResult.fromResponse(resonse);
  }
}

class SaveDataResult {
  bool isOk = false;
  //
  String objectId = "";
  String updated = "";
  String created = "";
  String ownerId = "";
  String classId = "";

  //
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;

  SaveDataResult.fromResponse(TinyNetRequesterResponse r) {
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
    if (keyValues.containsKey("updated")) {
      updated = keyValues["updated"];
    }
    if (keyValues.containsKey("created")) {
      created = keyValues["created"];
    }
    if (keyValues.containsKey("ownerId")) {
      ownerId = keyValues["ownerId"];
    }
    if (keyValues.containsKey("objectId")) {
      objectId = keyValues["objectId"];
    }
    if (keyValues.containsKey("___class")) {
      classId = keyValues["___class"];
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
