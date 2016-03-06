part of hetima_mbaas_net_flutter;

class TinyNetFlutterBuilder extends TinyNetBuilder {
  Future<TinyNetRequester> createRequester() async {
    return new TinyNetFlutterHttpRequester();
  }
}

class TinyNetFlutterHttpRequester extends TinyNetRequester {
  Future<TinyNetRequesterResponse> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    NetworkServiceProxy networkService = new NetworkServiceProxy.unbound();
    //print("#### shell : ${shell} ####");
    shell.connectToService("m", networkService);

    UrlLoaderProxy loader = new UrlLoaderProxy.unbound();
    UrlRequest request = new UrlRequest();

    List<HttpHeader> mojoHeaders = <HttpHeader>[];
    headers.forEach((String name, String value) {
      HttpHeader header = new HttpHeader()
        ..name = name
        ..value = value;
      mojoHeaders.add(header);
    });
    request.url = url; //Uri.base.resolve(url).toString();
    request.autoFollowRedirects = false;
    request.method = type;
    request.headers = mojoHeaders;

    {
      if (data != null) {
        print("#####---------(0) ${(UTF8.decode((UTF8.encode(data) as Uint8List).buffer.asUint8List()))}");
        ByteData d = null;

        if (data is String) {
          print("###ST# ${data}");
          d = new ByteData.view((UTF8.encode(data) as Uint8List).buffer); //(UTF8.encode(data) as Uint8List).buffer.asByteData();
        } else if (data is TypedData) {
          d = data.buffer.asByteData();
        } else if (data is ByteBuffer) {
          d = data.asByteData();
        } else if (data is List) {
          d = new ByteData.view(new Uint8List.fromList(data).buffer);
        } else if (data is ByteData) {
          d = data;
        } else {
          throw new UnsupportedError("");
        }
        core.MojoDataPipe pipe = new core.MojoDataPipe();
        core.DataPipeFiller.fillHandle(pipe.producer, d);
        request.body = <core.MojoDataPipeConsumer>[pipe.consumer];
        /*new Future((){
          pipe.producer.write(d);
          pipe.producer.handle.close();
        });*/

      }
    }
    networkService.ptr.createUrlLoader(loader);
    UrlResponse response = (await loader.ptr.start(request)).response;
    ByteData d1 = await core.DataPipeDrainer.drainHandle(response.body);
    Map<String, String> retHeader = {};
    for (HttpHeader h in response.headers) {
      retHeader[h.name] = h.value;
    }
    print("#####---------(6) ${response.statusCode} ${UTF8.decode(d1.buffer.asUint8List())}");
    return new TinyNetRequesterResponse(response.statusCode, retHeader, d1.buffer);
  }


  Future<TinyNetRequesterResponse> requestA(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    // url, {Map<String, String> headers, body}
    ht.Response response = await ht.post(url, headers:headers, body:data);
    return new TinyNetRequesterResponse(response.statusCode, {}, response.bodyBytes.buffer);
  }
}

/*



  Future<TinyNetRequesterResponse> requestA(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    // url, {Map<String, String> headers, body}
    ht.Response response = await ht.post(url, headers:headers, body:data);
    return new TinyNetRequesterResponse(response.statusCode, {}, response.bodyBytes.buffer);
  }

  Future<TinyNetRequesterResponse> requestB(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    NetworkServiceProxy networkService = new NetworkServiceProxy.unbound();
    shell.connectToService("m", networkService);

    //UrlLoaderProxy loader = new UrlLoaderProxy.unbound();
    UrlRequest request = new UrlRequest();

    List<HttpHeader> mojoHeaders = <HttpHeader>[];
    headers.forEach((String name, String value) {
      HttpHeader header = new HttpHeader()
        ..name = name
        ..value = value;
      mojoHeaders.add(header);
    });
    request.url = url;//Uri.base.resolve(url).toString();
    request.autoFollowRedirects = false;
    request.method = type;
    request.headers = mojoHeaders;

    {
      if (data != null) {
        print("#####---------(0) ${(UTF8.decode((UTF8.encode(data) as Uint8List).buffer.asUint8List()))}");
        ByteData d = null;

        if (data is String) {
          print("###ST# ${data}");
          d = new ByteData.view((UTF8.encode(data) as Uint8List).buffer);//(UTF8.encode(data) as Uint8List).buffer.asByteData();
        } else if (data is TypedData) {
          d = data.buffer.asByteData();
        } else if (data is ByteBuffer) {
          d = data.asByteData();
        } else if (data is List) {
          d = new ByteData.view(new Uint8List.fromList(data).buffer);
        } else if( data is ByteData) {
          d = data;
        } else {
          throw new UnsupportedError("");
        }
        core.MojoDataPipe pipe = new core.MojoDataPipe();
        core.DataPipeFiller.fillHandle(pipe.producer, d);
        request.body = <core.MojoDataPipeConsumer>[pipe.consumer];
      }
    }
    // force content-type is setted to application/x-www-form-urlencoded
    UrlResponse response = await fetch(request);
    ByteData d1 = await core.DataPipeDrainer.drainHandle(response.body);
    Map<String, String> retHeader = {};
    for (HttpHeader h in response.headers) {
      retHeader[h.name] = h.value;
    }
    print("#####---------(6) ${response.statusCode} ${UTF8.decode(d1.buffer.asUint8List())}");
    return new TinyNetRequesterResponse(response.statusCode, retHeader, d1.buffer);
  }

  */
