import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  const RadioButton(
      {super.key, required this.value, required this.selectedValue});

  final int value;
  final ValueNotifier<int> selectedValue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: selectedValue,
        builder: (context, selected, child) {
          return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Radio<int>(
              value: value,
              groupValue: selected,
              onChanged: (newValue) {
                if (newValue != null) {
                  selectedValue.value = newValue;
                }
              },
            ),
            Text(value.toString()),
          ]);
        });
  }
}
