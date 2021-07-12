import 'package:flutter/material.dart';

class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    Key? key,
    required this.labelText,
    required this.value,
    required this.onChanged,
    this.secondaryLabel,
    this.min: 0,
    this.max: 100,
    this.divisions,
  }) : super(key: key);

  final String labelText;
  final double value;
  final ValueChanged<double>? onChanged;
  final String? secondaryLabel;
  final double min;
  final double max;
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            labelText,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            divisions: divisions,
            label: secondaryLabel,
          ),
        ),
      ],
    );
  }
}
