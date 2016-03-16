part of hetima_mbaas_net_tetorica;

class TinyNetTetoricaBuilder extends TinyNetBuilder {
  tet.TetSocketBuilder builder;
  TinyNetTetoricaBuilder(this.builder) {}

  Future<TinyNetRequester> createRequester() async {
    return new TinyNetTetoricaHttpRequester(builder);
  }
}

class TinyNetTetoricaHttpRequester extends TinyNetRequester {
  tet.TetSocketBuilder builder;
  TinyNetTetoricaHttpRequester(this.builder) {}

  Future<TinyNetRequesterResponse> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    tet.HttpClientHelper cl = new tet.HttpClientHelper(builder);

    tet.HttpClientResponse res = null;
    Uri uri = Uri.parse(url);
    List<int> dat = const [];
    if (data is List<int>) {
      dat = data;
    } else if (data is ByteBuffer) {
      dat = data.asUint8List();
    } else if (data is ByteData) {
      dat = data.buffer.asUint8List();
    } else if (data is String) {
      dat = UTF8.encode(data);
    }

    if (type.toUpperCase() == TinyNetRequester.TYPE_POST) {
      res = await cl.post(uri.host, uri.port, "${uri.path}?${uri.query}", dat, header: headers, useSecure: (uri.scheme == "https"));
    } else if (type.toUpperCase() == TinyNetRequester.TYPE_GET) {
      res = await cl.get(uri.host, uri.port, "${uri.path}?${uri.query}", header: headers, useSecure: (uri.scheme == "https"));
    } else if (type.toUpperCase() == TinyNetRequester.TYPE_PUT) {
      res = await cl.put(uri.host, uri.port, "${uri.path}?${uri.query}", dat, header: headers, useSecure: (uri.scheme == "https"));
    } else if (type.toUpperCase() == TinyNetRequester.TYPE_DELETE) {
      res = await cl.delete(uri.host, uri.port, "${uri.path}?${uri.query}", header: headers, useSecure: (uri.scheme == "https"));
    } else {
      throw new UnsupportedError("");
    }

    Map<String, String> retHeader = {};
    for (tet.HttpResponseHeaderField h in res.message.headerField) {
      retHeader[h.fieldName] = h.fieldValue;
    }
    Uint8List v = new Uint8List.fromList(await res.body.getAllBytes());
    return new TinyNetRequesterResponse(res.message.line.statusCode, retHeader, v.buffer);
  }
}
