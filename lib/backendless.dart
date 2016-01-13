library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';

class Backendless {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  Backendless(this.builder, this.applicationId, this.secretKey) {}

  Future<LoginResult> login(String name, String pass, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(TinyNetRequester.TYPE_POST, "https://api.backendless.com/${version}/users/login", headers: {"application-id": applicationId, "secret-key": secretKey, "application-type": "REST", "Content-Type": "application/json"});
    return new LoginResult.fromResponse(resonse);
  }
/*
  Future<CurlResult> regist(String name, String pass) async {
    Curl curl = new Curl();
    CurlResult r = await curl.post("https://api.backendless.com/v1/users/register",
    """{"password":"${pass}", "email":"${name}"}""",
    headers: {
      "application-id": "",
      "secret-key": "",
      "application-type": "REST",
      "Content-Type":"application/json"});
    if (r.buffer != null && r.status == 200) {
      print("##1# ${r.status} ${UTF8.decode(r.buffer.asUint8List())}");
    } else {
      print("##2# ${r.status}");
    }
    return r;
  }

  Future<CurlResult> logout(String userToken) async {
    print("###${userToken}");
    MyStatus.instance.userToken = "";
    Curl curl = new Curl();
    CurlResult r = await curl.get("https://api.backendless.com/v1/users/logout",
    headers: {
       "application-id": "",
       "secret-key": "",
       "application-type": "REST",
       "user-token": "${userToken}",
       "Content-Type":"application/json"});
    if (r.buffer != null && r.status == 200) {
      print("##1# ${r.status} ${UTF8.decode(r.buffer.asUint8List())}");
    } else {
      print("##2# ${r.status}");
    }
    return r;
  }
  */
}

class LoginResult {
  bool isOk = false;
  String userToken = "";
  String objectId = "";
  String message = "";
  int code = 9999;

  LoginResult.fromResponse(TinyNetRequesterResponse r) {
    String message = UTF8.decode(r.response.asUint8List());
    Map cont = {};
    try {
      cont = JSON.decode(message);
    } catch (e) {}

    if (cont.containsKey("user-token")) {
      userToken = cont["user-token"];
    }
    if (cont.containsKey("objectId")) {
      objectId = cont["objectId"];
    }
    if (cont.containsKey("code")) {
      code = cont["code"];
    }
    if (cont.containsKey("message")) {
      message = cont["message"];
    }

    if (r.status == 200 && userToken != null && userToken.length != 0) {
      isOk = true;
    } else {
      isOk = false;
    }
  }
}
