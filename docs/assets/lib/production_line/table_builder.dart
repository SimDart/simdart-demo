import 'dart:math' as math;
import 'package:flutter/material.dart';

class TableBuilder {
  final List<RowBuilder> _rows = [];

  double rowHeight = 32;
  EdgeInsets padding = EdgeInsets.fromLTRB(8, 4, 8, 4);

  RowBuilder row() {
    RowBuilder row = RowBuilder._();
    _rows.add(row);
    return row;
  }

  Widget build() {
    int maxColumnsCount = _rows.fold(
        0, (previous, row) => math.max(previous, row._children.length));

    List<TableRow> rows = [];
    for (RowBuilder row in _rows) {
      List<Widget> cells = [];
      for (int c = 0; c < maxColumnsCount; c++) {
        if (c < row._children.length) {
          cells.add(_cell(row._children[c]));
        } else {
          cells.add(_cell(Container()));
        }
      }
      rows.add(TableRow(children: cells));
    }

    return Table(defaultColumnWidth: IntrinsicColumnWidth(), children: rows);
  }

  Widget _cell(Widget child) {
    return SizedBox(
        height: rowHeight,
        child: Container(
            padding: padding, alignment: Alignment.centerRight, child: child));
  }
}

class RowBuilder {
  RowBuilder._();

  final List<Widget> _children = [];

  RowBuilder add(Widget child) {
    _children.add(child);
    return this;
  }
}
