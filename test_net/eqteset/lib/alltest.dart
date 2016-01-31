library alltest;
import 'dart:convert';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'package:unittest/unittest.dart';

kicktest(TinyNetBuilder builder) async {
  print("## --1--");
  group("", () {
    test("post", () async {
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response =
      await requester.request(
        TinyNetRequester.TYPE_POST,//
        "http://httpbin.org/post",//
        headers: {
          "nono":"nano",
          "Content-Type": "application/json"},//
        data: JSON.encode({"message":"hello!!"}));
      print("${UTF8.decode(response.response.asUint8List())}");
      Map<String,Object> ret = JSON.decode(UTF8.decode(response.response.asUint8List()));
      expect("application/json",(ret["headers"]as Map)["Content-Type"]);
      expect("nano",(ret["headers"]as Map)["Nono"]);
      expect("hello!!",(ret["json"]as Map)["message"]);
      return "";
    });

    test("put", () async {
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response =
      await requester.request(
        TinyNetRequester.TYPE_PUT,//
        "http://httpbin.org/put",//
        headers: {
          "nono":"nano",
          "Content-Type": "application/json"},//
        data: JSON.encode({"message":"hello!!"}));
      print("${UTF8.decode(response.response.asUint8List())}");
      Map<String,Object> ret = JSON.decode(UTF8.decode(response.response.asUint8List()));
      expect("application/json",(ret["headers"]as Map)["Content-Type"]);
      expect("nano",(ret["headers"]as Map)["Nono"]);
      expect("hello!!",(ret["json"]as Map)["message"]);
      return "";
    });
  });
}
