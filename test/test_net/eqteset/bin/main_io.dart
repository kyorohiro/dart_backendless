// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:umiuni2d_netbox.dartio/tinynet_dartio.dart';

import 'package:test_net/alltest.dart' as t;

main() async {
  TinyNetDartIoBuilder builder = new TinyNetDartIoBuilder();
  t.kicktest(builder);
}
