import 'package:demoflu/demoflu.dart';
import 'package:simdart_demo/production_line/production_line_page.dart';

void main() {
  DemoFluApp app = DemoFluApp(title: 'SimDart', rootMenus: _rootMenus);
  app.run();
}

List<DemoMenuItem> get _rootMenus =>
    [_examples];

DemoMenuItem get _examples =>
    DemoMenuItem('Examples', children: [_productionLine]);

DemoMenuItem get _productionLine =>
    DemoMenuItem('Production line', page: () => ProductionLinePage());

