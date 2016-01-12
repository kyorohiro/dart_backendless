// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:hetima_backendless/backendless.dart';
import 'package:hetima_backendless/backendless_html5.dart';

main() async {
  HetimaHtml5Builder builder = new HetimaHtml5Builder();
  HetimaRequester requester = await builder.createRequester();
  requester.request(HetimaRequester.TYPE_POST, "http://localhost:8080/");
}
