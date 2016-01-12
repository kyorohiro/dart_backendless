// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:typed_data';
import 'dart:convert';
import 'package:hetima_backendless/backendless.dart';
import 'package:unittest/unittest.dart';

main() async {
  print("## --1--");
  group("", () {
    test("aa", () async {
      HetimaHtml5Builder builder = new HetimaHtml5Builder();
      HetimaRequester requester = await builder.createRequester();
      HetimaResponse response = await requester.request(HetimaRequester.TYPE_POST, "http://localhost:8080/method");
      expect("post", UTF8.decode(response.response.asUint8List()).toLowerCase());
//      response = await requester.request(HetimaRequester.TYPE_POST, "http://localhost:8080/header");
//      print("## ${response.status} ${response.headers} ${UTF8.decode(response.response.asUint8List())}");
      return "";
    });
  });
}
