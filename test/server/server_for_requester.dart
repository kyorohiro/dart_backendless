library testserver.requester;
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

void main(List<String> args) {

  ArgParser parser = new ArgParser()
  ..addOption('port', abbr: 'p', defaultsTo: '8080')
  ..addOption('sport', abbr: 's', defaultsTo: '8443')
  ..addOption('cert', abbr: 'c', defaultsTo: null)
  ..addOption('work', abbr: 'w', defaultsTo: '/tmp')
  ..addOption('ip', abbr: 'i', defaultsTo: '0.0.0.0');

  ArgResults result = parser.parse(args);
  int port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });
  int sport = int.parse(result['sport'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  String ip = result['ip'];
  String path = result['cert'];

  if(path == null || path == "") {
    startWithNoSequre(ip, port);
  } else {
    startWithNoSequre(ip, port);
    startWithSecure(ip, sport, path);
  }
}

void startWithSecure(String ip, int port, String path) {
  String key = Platform.script.resolve("${path}/key.pem").toFilePath();
  String crt = Platform.script.resolve("${path}/certificate.pem").toFilePath();
  SecurityContext context = new SecurityContext();
  context.useCertificateChain(crt);
  context.usePrivateKey(key, password: "");
  HttpServer.bindSecure(ip, port, context)
  .then((HttpServer server) {
    server.listen(onRequest);
  });
}

void startWithNoSequre(String ip, int port) {
  HttpServer.bind(ip, port)
  .then((HttpServer server) {
    server.listen(onRequest);
  });
}

onRequest(HttpRequest request) {
  request.response.done.then((_){
    print("${_}");
  });
  request.response.headers.add("test", "a");
  request.response.headers.add("Access-Control-Allow-Origin", "*");
  print("##A#${request.uri.path}#");
  if(request.uri.path == "/header") {
    StringBuffer buffer = new StringBuffer();
    request.headers.forEach((String name, List<String> values){
      for(String v in values) {
        request.response.add(UTF8.encode("${name}:${v}\n"));
      }
    });
    request.response.add(UTF8.encode(buffer.toString()));
    request.response.close();
  }
  else if(request.uri.path == "/method"){
    request.response.add(UTF8.encode(request.method));
    request.response.close();
  }
  else if(request.uri.path == "/content") {
    request.listen((List<int> v){
      request.response.add(v);
     },onDone: (){
      request.response.close();
    });
  }
  else {
    request.response.add(UTF8.encode("hello!!"));
    request.response.close();
  }
}
