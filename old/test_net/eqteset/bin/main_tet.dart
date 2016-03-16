// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:umiuni2d_netbox/tinynet_tetorica.dart';
import 'package:tetorica/net_dartio.dart' as tet;
import 'package:test_net/alltest.dart' as t;

main() async {
  TinyNetTetoricaBuilder builder = new TinyNetTetoricaBuilder(new tet.TetSocketBuilderDartIO());
  t.kicktest(builder);
}
