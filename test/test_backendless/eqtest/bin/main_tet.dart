import 'package:umiuni2d_netbox.tetorica/tinynet_tetorica.dart';
import 'package:tetorica/net_dartio.dart' as tet;
import 'package:test_backendless/alltests.dart' as t;

main() async {
  TinyNetTetoricaBuilder builder = new TinyNetTetoricaBuilder(new tet.TetSocketBuilderDartIO());
  t.kicktests(builder);
}
