library test_backendless;

import 'package:unittest/unittest.dart';
import 'package:umiuni2d_netbox/parse.dart';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'dart:convert' as conv;

import 'package:crypto/crypto.dart' as crypt;

String _key = "44Gr44KT44GS44KT44Gw44KT44GY44GV44GE44GK44GG44GM44GG44G+44Os44Kk44K444O844Oz44K744Kk44OQ44O844OY44O844Ky44Oz44Gq44KL44GX44G+44KG44KK44GS44KT44GY44KF44GG44G244KT44GX44KH";
String _restId = "0dnCkfbepMndh/f3oeSIhbTRiLj7tuT7qMKxrLG6tu72m8jL1cTljA==";
String _appId = "lvfyl/T5keT3t9X6iND3lfPrttWo19Pwjcfmm7TajMO3lfPCurfThA==";

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
  UserTest user = new UserTest();
  user.kick(builder, appId, restId);
}

class UserTest {
  kick(TinyNetBuilder builder, String applicationId, String secretKey) async {
    ParseUser user = new ParseUser(builder, applicationId, secretKey);
    SignUpUserResult signupResult = await user.signup("kyorohiro", "asdfasdf");
    print("${signupResult.statusCode} ${signupResult.keyValues} ${signupResult.locationHeaderValue}");

    LoginUserResult loginResult = await user.login("kyorohiro", "asdfasdf");
    print("${loginResult.statusCode} ${loginResult.keyValues} ${loginResult.locationHeaderValue} ${loginResult.sessionToken}");
  }
}
