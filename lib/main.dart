import 'package:demoflu/demoflu.dart';
import 'package:simdart_demo/get_started/get_started_page.dart';

void main() {
  DemoFluApp app = DemoFluApp(title: 'SimDart', rootMenus: _rootMenus);
  app.run();
}

List<DemoMenuItem> get _rootMenus =>
    [_getStarted];

DemoMenuItem get _getStarted =>
    DemoMenuItem('Get started', page: () => GetStartedPage());

