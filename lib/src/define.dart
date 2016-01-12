// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of hetima_backendless;

class HtmlBuilder {}

abstract class HetimaBuilder {
  Future<HetimaRequester> createRequester();
}

abstract class HetimaRequester {
  static final String TYPE_POST = "POST";
  static final String TYPE_GET = "GET";
  Future<HetimaResponse> request(String type, String url, {Object data:null, Map<String, String> headers: null}) ;
}

class HetimaResponse {
  int _status;
  int get status => _status;
  ByteBuffer _response;
  ByteBuffer get response => (_response == null ? new Uint8List.fromList([]) : _response);
  Map<String,String> _headers = {};
  Map<String,String> get headers => _headers;
  HetimaResponse(this._status, Map<String,String> headers, this._response) {
    _headers.addAll(headers);
  }
}
