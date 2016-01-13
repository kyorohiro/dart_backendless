// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:typed_data';
import 'dart:convert';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'package:umiuni2d_netbox/tinynet_html5.dart';
import 'package:unittest/unittest.dart';

main() async {
  print("## --1--");
  group("", () {
    test("method", () async {
      HetimaHtml5Builder builder = new HetimaHtml5Builder();
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response = await requester.request(TinyNetRequester.TYPE_POST, "http://localhost:8080/method");
      expect("post", UTF8.decode(response.response.asUint8List()).toLowerCase());
      return "";
    });

    test("header", () async {
      HetimaHtml5Builder builder = new HetimaHtml5Builder();
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response = await requester.request(
        TinyNetRequester.TYPE_POST,
        "http://localhost:8080/header",
        headers: {"nono":"nano"});
        expect(true, UTF8.decode(response.response.asUint8List()).toLowerCase().contains("nono:nano"));
      return "";
    });
    test("content", () async {
      HetimaHtml5Builder builder = new HetimaHtml5Builder();
      TinyNetRequester requester = await builder.createRequester();
      TinyNetRequesterResponse response = await requester.request(
        TinyNetRequester.TYPE_POST,
        "http://localhost:8080/content", data: "hello!!");
        expect("hello!!", UTF8.decode(response.response.asUint8List()));
      return "";
    });
  });
}
