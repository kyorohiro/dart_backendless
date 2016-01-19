library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';

part 'src/backendless/user.dart';
part 'src/backendless/data.dart';


class BackendlessFile {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessFile(this.builder, this.applicationId, this.secretKey) {}

  Future<PutFileResult> putFile(String path, Object data, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type":"multipart/form-data" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/files/${path}";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        url, //
        headers: headers, //
        data: data);

    return new PutFileResult.fromResponse(resonse);
  }
}

class BackendlessResultBase {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;

  BackendlessResultBase.fromResponse(TinyNetRequesterResponse r) {
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

class PutFileResult extends BackendlessResultBase {
  PutFileResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r){
  }
}
