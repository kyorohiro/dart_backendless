library hetima_backendless_flutter;

import 'dart:async';
import 'dart:typed_data';
import 'backendless.dart';
//
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mojo/core.dart' as core;
import 'package:mojo/mojo/url_request.mojom.dart';
import 'package:mojo/mojo/url_response.mojom.dart';
import 'package:mojo_services/mojo/network_service.mojom.dart';
import 'package:mojo_services/mojo/url_loader.mojom.dart';
import 'package:mojo/mojo/http_header.mojom.dart';
export 'package:mojo/mojo/url_response.mojom.dart' show UrlResponse;
part 'src/dartflutterver.dart';

class HetimaFlutterBuilder {
  Future<HetimaRequester> createRequester() async {
    return new HetimaFlutterHttpRequester();
  }
}

class HetimaFlutterHttpRequester extends HetimaRequester {
  Future<HetimaResponse> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
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
    return new HetimaResponse(response.statusCode, retHeader, d.buffer);
  }
}
