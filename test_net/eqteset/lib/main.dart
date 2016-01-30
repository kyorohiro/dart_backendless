
import 'dart:convert';
import 'package:umiuni2d_netbox/tinynet.dart';
import 'package:umiuni2d_netbox/tinynet_flutter.dart';
import 'package:unittest/unittest.dart';
import 'package:test_net/alltest.dart' as t;
main() async {
  TinyNetFlutterBuilder builder = new TinyNetFlutterBuilder();
  t.kicktest(builder);
}
