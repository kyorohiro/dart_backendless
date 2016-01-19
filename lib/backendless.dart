library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypt;

part 'src/backendless/user.dart';
part 'src/backendless/data.dart';
part 'src/backendless/file.dart';

class BackendlessResultBase {
  bool isOk = false;
  String objectId = "";
  String message = "";
  int code = 9999;
  Map keyValues = {};
  int statusCode = 0;
  String utf8binary = "";
  Uint8List binary = new Uint8List.fromList([]);

  BackendlessResultBase.fromResponse(TinyNetRequesterResponse r, {bool isJson: true}) {
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

    if (keyValues.containsKey("code")) {
      code = keyValues["code"];
    }
    if (keyValues.containsKey("message")) {
      message = keyValues["message"];
    }
  }
}
