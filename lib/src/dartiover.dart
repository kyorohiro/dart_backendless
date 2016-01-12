part of hetima_backendless_dartio;

class HetimaDartIoBuilder {
  Future<HetimaRequester> createRequester() async {
    return new HetimaDartIoHttpRequester();
  }
}

class HetimaDartIoHttpRequester extends HetimaRequester {
  Future<HetimaResponse> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    io.HttpClient cl = new io.HttpClient();
    //cl.
    io.HttpClientRequest req = null;
    if (type.toUpperCase() == HetimaRequester.TYPE_POST) {
      req = await cl.postUrl(Uri.parse(url));
    } else if (type.toUpperCase() == HetimaRequester.TYPE_GET) {
      req = await cl.getUrl(Uri.parse(url));
    } else {
      throw new UnsupportedError("");
    }
    for (String k in headers.keys) {
      req.headers.add(k, headers[k]);
    }
    if (data != null) {
      if (data == ByteBuffer) {
        req.add((data as ByteBuffer).asUint8List());
      } else {
        req.write(data);
      }
    }
    io.HttpClientResponse res = await req.close();
    List<int> vv = [];
    await for (List<int> v in res.listen) {
      vv.addAll(v);
    }
    return new HetimaResponse(res.statusCode, headers, new Uint8List.fromList(vv).buffer);
  }
}
