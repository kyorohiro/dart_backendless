import 'package:umiuni2d_netbox/tinynet_flutter.dart';
import 'package:test_backendless/alltests.dart' as te;
import 'dart:async';
import 'package:flutter/material.dart';

a() async {
  new Future(() {
    te.kicktests(new TinyNetFlutterBuilder());
  });
}

void main() {
  runApp(new Center(child: new Text("Hello!!")));
  a();
}
