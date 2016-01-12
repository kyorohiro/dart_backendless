// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of hetima_backendless;

class HtmlBuilder {}

class HetimaHtml5Builder {
  Future<HetimaRequester> createRequester() async {
    return new HetimaHtml5HttpRequester();
  }
}
abstract class HetimaBuilder {
  Future<HetimaRequester> createRequester();
}

abstract class HetimaRequester {
  static final String TYPE_POST = "POST";
  static final String TYPE_MPOST = "MPOST";
  static final String TYPE_GET = "GET";
  Future<HetimaResponse> request(String type, String url, Object data, {Map<String, String> headers: null}) ;
}

class HetimaHtml5HttpRequester extends HetimaRequester {
  Future<HetimaResponse> request(String type, String url, Object data, {Map<String, String> headers: null}) {
    if (headers == null) {
      headers = {};
    }
    Completer<HetimaResponse> c = new Completer();
    try {
      html.HttpRequest req = new html.HttpRequest();
      req.responseType = "arraybuffer";
      req.open(type, url, async: true);
      for (String k in headers.keys) {
        req.setRequestHeader(k, headers[k]);
      }
      req.onReadyStateChange.listen((html.ProgressEvent e) {
        if (req.readyState == html.HttpRequest.DONE) {
          c.complete(new HetimaResponse(req.status, req.response));
        }
      });
      req.onError.listen((html.ProgressEvent e) {
        c.completeError(e);
      });
      if (data == null) {
        req.send();
      } else {
        req.send(data);
      }
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}

class HetimaResponse {
  int _status;
  int get status => _status;
  ByteBuffer _response;
  ByteBuffer get response => (_response == null ? new Uint8List.fromList([]) : _response);
  HetimaResponse(this._status, this._response) {}
}
