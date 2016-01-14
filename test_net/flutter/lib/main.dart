
import 'dart:convert';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'package:umiuni2d_netbox/tinynet_flutter.dart';
import 'package:unittest/unittest.dart';

main() async {

  group("", () {
    test("",() async{
      print("## --1--");
      TinyNetFlutterBuilder builder = new TinyNetFlutterBuilder();
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response = await requester.request(TinyNetRequester.TYPE_GET, "https://raw.githubusercontent.com/kyorohiro/dart_hetimabackendless/master/README.md");
      print("#AA##${UTF8.decode(response.response.asUint8List())}");
    });
    /*
    test("method", () async {
      HetimaFlutterBuilder builder = new HetimaFlutterBuilder();
      HetimaRequester requester = await builder.createRequester();
      HetimaResponse response = await requester.request(HetimaRequester.TYPE_POST, "http://localhost:8080/method");
      expect("post", UTF8.decode(response.response.asUint8List()).toLowerCase());
      return "";
    });

    test("header", () async {
      HetimaFlutterBuilder builder = new HetimaFlutterBuilder();
      HetimaRequester requester = await builder.createRequester();
      HetimaResponse response = await requester.request(
        HetimaRequester.TYPE_POST,
        "http://localhost:8080/header",
        headers: {"nono":"nano"});
        expect(true, UTF8.decode(response.response.asUint8List()).toLowerCase().contains("nono:nano"));
      return "";
    });
    test("content", () async {
      HetimaFlutterBuilder builder = new HetimaFlutterBuilder();
      HetimaRequester requester = await builder.createRequester();
      HetimaResponse response = await requester.request(
        HetimaRequester.TYPE_POST,
        "http://localhost:8080/content", data: "hello!!");
        expect("hello!!", UTF8.decode(response.response.asUint8List()));
      return "";
    });
    */
  });
}
