library alltest;
import 'dart:convert';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'package:unittest/unittest.dart';

kicktest(TinyNetBuilder builder) async {
  print("## --1--");
  group("", () {
    test("method", () async {
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response =
      await requester.request(TinyNetRequester.TYPE_POST, "http://httpbin.org/post",headers: {"nono":"nano"},data: "hello!!");
      print("${UTF8.decode(response.response.asUint8List())}");
      return "";
    });
  });
}
