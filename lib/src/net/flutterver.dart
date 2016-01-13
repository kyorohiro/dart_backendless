part of hetima_mbaas_net_flutter;

class HetimaFlutterBuilder {
  Future<TinyNetRequester> createRequester() async {
    return new HetimaFlutterHttpRequester();
  }
}

class HetimaFlutterHttpRequester extends TinyNetRequester {
  Future<TinyNetRequesterResponse> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    print("#####---------(1)");
    NetworkServiceProxy networkService = new NetworkServiceProxy.unbound();
    shell.connectToService("m", networkService);

    UrlLoaderProxy loader = new UrlLoaderProxy.unbound();
    networkService.ptr.createUrlLoader(loader);
    UrlRequest request = new UrlRequest();
    request.url = Uri.base.resolve(url).toString();
    request.autoFollowRedirects = true;
    request.method = type;

    for (String k in headers.keys) {
      request.headers.add(new HttpHeader()
        ..name = k
        ..value = headers[k]);
    }
    networkService.close();
    //request.body =
    print("#####---------(3)");
    {
      if (data != null) {
        ByteData d = null;
        core.MojoDataPipe pipe = new core.MojoDataPipe();
        request.body = <core.MojoDataPipeConsumer>[pipe.consumer];
        if (data is String) {
          d = (UTF8.encode(data) as Uint8List).buffer.asByteData();
        } else if (data is TypedData) {
          d = data.buffer.asByteData();
        } else if (data is ByteBuffer) {
          d = data.asByteData();
        } else if (data is List) {
          d = new ByteData.view(new Uint8List.fromList(data).buffer);
        } else {
          throw new UnsupportedError("");
        }
        core.DataPipeFiller.fillHandle(pipe.producer, d);
      }

    }
    print("#####---------(3-9)");
    UrlResponse response = (await loader.ptr.start(request)).response;
    core.MojoDataPipeConsumer consumer = response.body;
    print("#####---------(4)");
    ByteData d = await core.DataPipeDrainer.drainHandle(consumer);
    print("#####---------(5)");
    Map<String, String> retHeader = {};
    for (HttpHeader h in response.headers) {
      retHeader[h.name] = h.value;
    }
    print("#####---------(6)");
    return new TinyNetRequesterResponse(response.statusCode, retHeader, d.buffer);
  }
}
