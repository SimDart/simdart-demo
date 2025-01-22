import 'package:demoflu/demoflu.dart';
import 'package:flutter/widgets.dart';
import 'package:simdart_demo/production_line/production_line_example.dart';

class ProductionLinePage extends DemoFluPage {
  @override
  void buildSections(BuildContext context, PageSections sections) {
    sections.widget((context) => ProductionLineExample());

    sections.code('lib/production_line/production_line.dart',
        title: 'Simulation code:');
  }
}
