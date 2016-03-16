library hetima_mbaas_backendless;

import 'tinynet.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypt;

class GithubAuth {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;

  GithubAuth(this.builder, this.applicationId, this.secretKey) {
    ;
  }

  Future basicAuth() {
    ;
  }
  Future auth() async {

  }
}
