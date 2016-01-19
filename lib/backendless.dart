library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypt;

part 'src/backendless/user.dart';
part 'src/backendless/data.dart';


class BackendlessFile {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessFile(this.builder, this.applicationId, this.secretKey) {}

  Future<PutFileResult> putBinary(String path, Object data, String userToken, {String opt:"?overwrite=true", String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type":"text/plain" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/files/binary/${path}${opt}";
    if(data is String) {
      data = crypt.BASE64.encode(UTF8.encode(data));
    }
    else if(data is ByteData) {
      data = crypt.BASE64.encode((data as ByteData).buffer.asUint8List());
    }
    else if(data is ByteBuffer) {
      data = crypt.BASE64.encode((data as ByteBuffer).asUint8List());
    }
    else if(data is List<int>) {
      data = crypt.BASE64.encode((data as List<int>));
    }
    else {
      throw new UnsupportedError("unsupport data type");
    }
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
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
  String utf8binary = "";

  BackendlessResultBase.fromResponse(TinyNetRequesterResponse r) {
    utf8binary = UTF8.decode(r.response.asUint8List());
    if(utf8binary == null) {
      utf8binary = "";
    }
    statusCode = r.status;
    if (r.status == 200) {
      isOk = true;
    } else {
      isOk = false;
    }

    try {
      var v = JSON.decode(utf8binary);
      if(v is Map) {
        keyValues = v;
      } else {
        print("--${v}");
      }
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
  String fileURL = "";

  PutFileResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r){
    fileURL = utf8binary;
  }
}
