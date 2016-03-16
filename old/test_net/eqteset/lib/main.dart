import 'package:umiuni2d_netbox/tinynet_flutter.dart';
import 'package:test_net/alltest.dart' as t;
import 'dart:async';
import 'package:flutter/material.dart';

a() async {
  new Future(() {
    TinyNetFlutterBuilder builder = new TinyNetFlutterBuilder();
    t.kicktest(builder);
  });
}

void main() {
  runApp(new Center(child: new Text("Hello!!")));
  a();
}
