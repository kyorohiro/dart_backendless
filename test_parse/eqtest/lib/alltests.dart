library test_backendless;

import 'package:unittest/unittest.dart';
import 'package:umiuni2d_netbox/backendless.dart';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'dart:convert' as conv;

import 'package:crypto/crypto.dart' as crypt;

String _key = "44Gr44KT44GS44KT44Gw44KT44GY44GV44GE44GK44GG44GM44GG44G+44Os44Kk44K444O844Oz44K744Kk44OQ44O844OY44O844Ky44Oz44Gq44KL44GX44G+44KG44KK44GS44KT44GY44KF44GG44G244KT44GX44KH";
String _restId = "27GYoMPR0Le/obKl26yAoLSgzsfe0sC4p8S82rK/17my27G8";
String _appId = "17nt1LfXp7m/prWq2qyC1MTWzsfe1re40rnF17bMpbC007G8";

String get restId {
  List<int> v1 = crypt.CryptoUtils.base64StringToBytes(_key); //conv.BASE64.decode(_key);
  List<int> d1 = crypt.CryptoUtils.base64StringToBytes(_restId); //conv.BASE64.decode(_restId);
  for (int i = 0; i < v1.length && i < d1.length; i++) {
    d1[i] = d1[i] ^ v1[i];
  }
  return conv.UTF8.decode(d1);
}

String get appId {
  List<int> v1 = crypt.CryptoUtils.base64StringToBytes(_key); //conv.BASE64.decode(_key);
  List<int> d1 = crypt.CryptoUtils.base64StringToBytes(_appId); //conv.BASE64.decode(_appId);
  for (int i = 0; i < v1.length && i < d1.length; i++) {
    d1[i] = d1[i] ^ v1[i];
  }
  return conv.UTF8.decode(d1);
}

void kicktests(TinyNetBuilder builder) {
}
