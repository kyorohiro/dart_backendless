import 'dart:convert';

void main(List<String> args) {
  String pat = "にんげんばんじさいおうがうまレイジーンセイバーヘーゲンなるしまゆりげんじゅうぶんしょ";
  List<int> v = UTF8.encode(pat);
  List<int> d = UTF8.encode(args[0]);
  List<int> a = [];
  for (int i = 0; i < v.length && i < d.length; i++) {
    a.add(d[i] ^ v[i]);
  }
  String key = BASE64.encode(v);
  String value = BASE64.encode(a);
  print("#key#${key}#");
  print("#value#${value}#");
  print("#test 1#${UTF8.decode(BASE64.decode(key))}");
  print("#test 2#${UTF8.decode(d)}");
  {
    List<int> v1 = BASE64.decode(key);
    List<int> d1 = BASE64.decode(value);
    for (int i = 0; i < v1.length && i < d1.length; i++) {
      d1[i] = d1[i] ^ v1[i];
    }
    print("test 3#${UTF8.decode(d1)}");
  }
}
