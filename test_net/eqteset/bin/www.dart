import 'dart:io';
import 'dart:convert';
import 'dart:async';

main() async {
    SecureSocket socket = await SecureSocket.connect("api.backendless.com", 443);
    List<int> v = [];
    socket.listen((List<int> d){
      v.addAll(d);
    });
    socket.add(UTF8.encode("PUT /v1/files/binary/testFolder/savedNote.txt?overwrite=true HTTP/1.1\r\n"));

    socket.add(UTF8.encode("Host: api.backendless.com\r\n"));
    socket.add(UTF8.encode("Content-Type: text/plain\r\n"));
    socket.add(UTF8.encode("application-id: \r\n"));
    socket.add(UTF8.encode("secret-key:\r\n"));
    socket.add(UTF8.encode("application-type: REST\r\n"));
    socket.add(UTF8.encode("Content-Length: 16\r\n"));
    socket.add(UTF8.encode("\r\n"));
    socket.add(UTF8.encode("bXkgY29vbCBub3Rl\r\n"));


    new Future.delayed(new Duration(seconds: 5)).then((_){
      print("#### ${UTF8.decode(v)}");
    });
}
