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
  TestUser user = new TestUser();
  user.kick(builder, appId, restId);

  //
  TestData data = new TestData();
  data.kick(builder, appId, restId);

  //
  TestFile file = new TestFile();
  file.kick(builder, appId, restId);

  TestCounter counter = new TestCounter();
  counter.kick(builder, appId, restId);
}

class TestUser {
  kick(TinyNetBuilder builder, String applicationId, String secretKey) {
    test("a", () async {
      BackendlessUser user = new BackendlessUser(builder, applicationId, secretKey);
      //RegistResult ret1 =
      await user.regist({
        BackendlessUser.REGIST_EMAIL: "kyorohiro@gmail.com", //
        BackendlessUser.REGIST_NAME: "kyorohiro", //
        BackendlessUser.REGIST_PASSWORD: "asdfasdf"
      });
      //expect(true, ret1.isOk);
      LoginResult ret2 = await user.login("kyorohiro@gmail.com", "asdfasdf");
      print("${ret2.keyValues}");
      expect(true, ret2.isOk);
      UpdateUserPropertyResult ret22 = await user.updateUserProperty(ret2.objectId, ret2.userToken, {"name": "kyorohiro2"});
      expect(true, ret22.isOk);
      //
      GetUserPropertyResult ret21 = await user.getUserProperty(ret2.objectId, ["name", "email"]);
      print("#${ret21.keyValues} ${ret21.statusCode}");
      expect(true, ret21.isOk);
      expect("kyorohiro2", ret21.keyValues["name"]);
      expect("kyorohiro@gmail.com", ret21.keyValues["email"]);
      //
      LogoutResult ret3 = await user.logout(ret2.userToken);
      expect(true, ret3.isOk);

      //ResetPasswordResult ret4 = await user.resetPassword("kyorohiro");
      //print("${ret4.keyValues}");
      //expect(true, ret4.isOk);
      return "";
    });
  }
}

class TestData {
  kick(TinyNetBuilder builder, String applicationId, String secretKey) {
    test("a", () async {
      BackendlessData data = new BackendlessData(builder, applicationId, secretKey);
      SaveDataResult ret1 = await data.saveData("Test", {"text001": "hello22"});
      print("\n#A# ${ret1.keyValues}");
      expect(true, ret1.isOk);

      SearchBasicDataResult ret2 = await data.searchBasicDataFromLast("Test");
      print("\n#B# ${ret2.keyValues}");
      expect(true, ret2.isOk);

      SearchBasicDataResult ret3 = await data.searchBasicDataCollection("Test");
      print("\n#C# ${ret3.keyValues}");
      expect(true, ret3.isOk);

      DeleteDataResult ret4 = await data.deleteData("Test", ret2.objectId);
      print("\n#D# #${ret2.objectId} ${ret4.keyValues}");
      expect(true, ret4.isOk);
      return "";
    });
  }
}

class TestFile {
  kick(TinyNetBuilder builder, String applicationId, String secretKey) {
    test("a", () async {
      BackendlessUser user = new BackendlessUser(builder, applicationId, secretKey);
      LoginResult ret2 = await user.login("kyorohiro@gmail.com", "asdfasdf");

      BackendlessFile file = new BackendlessFile(builder, applicationId, secretKey);
      UploadBinaryResult ret1 = await file.uploadBinary("tests/text1.txt", "Hello World!!", ret2.userToken);
      print("\n#AAAAA# ${ret1.keyValues}");
      expect(true, ret1.isOk);

      DownloadBinaryResult ret3 = await file.downloadBinary("tests/text1.txt", ret2.userToken);
      print("\n#VVVVVV# ${ret3.keyValues}");
      expect(true, ret3.isOk);

      RenameFileResult ret5 = await file.renameFile("tests/text1.txt", "text2.txt", ret2.userToken);
      print("\n#ZZZZZZ# ${ret5.keyValues}");
      expect(true, ret5.isOk);

      MoveFileResult ret6 = await file.moveFile("tests/text2.txt", "tests/text3.txt", ret2.userToken);
      print("\n#ZZZZZA# ${ret6.keyValues}");
      expect(true, ret6.isOk);

      DeleteFileResult ret4 = await file.deleteFile("tests/text3.txt", ret2.userToken);
      print("\n#ZZZZZB# ${ret4.keyValues}");
      expect(true, ret4.isOk);
      return "";
    });
  }
}

class TestCounter {
  kick(TinyNetBuilder builder, String applicationId, String secretKey) {
    test("a", () async {
      BackendlessCounter counter = new BackendlessCounter(builder, applicationId, secretKey);
      {
        ResetCounterResult r = await counter.resetCurrent("test");
        expect(true, r.isOk);
      }
      {
        GetCurrentCounterResult r = await counter.getCurrrent("test");
        expect(r.count, 0);
      }
      {
        IncrementGetCounterResult r = await counter.incrementGet("test");
        expect(r.count, 1);
      }
      {
        IncrementGetCounterResult r = await counter.incrementGet("test",value: 100);
        expect(r.count, 101);
      }
      {
        IncrementGetCounterResult r = await counter.incrementGet("test",value: -100);
        expect(r.count, 1);
      }
      {
        DecrementGetCounterResult r = await counter.decrementGet("test");
        expect(r.count, 0);
      }
      {
        GetCompareandsetCounterResult r = await counter.getCompareandSet("test", 0,10);
        expect(r.counterUpdated, true);
      }

      {
        GetCurrentCounterResult r = await counter.getCurrrent("test");
        expect(r.count, 10);
      }
      {
        ResetCounterResult r = await counter.resetCurrent("test");
        expect(true, r.isOk);
      }
      {
        GetCurrentCounterResult r = await counter.getCurrrent("test");
        expect(0, r.count);
      }
      return "";
    });
  }
}
//BackendlessCounter
