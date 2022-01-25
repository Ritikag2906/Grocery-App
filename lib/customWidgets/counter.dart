library counter;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void CounterChangeCallback(int value);

class Counter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  Counter({
    required int initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.color = Colors.blue,
    this.textStyle = const TextStyle(),
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  int selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// indicates the color of fab used for increment and decrement
  Color color;

  /// text syle
  TextStyle textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    color = color;
    textStyle = textStyle;

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
              backgroundColor: color,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: const EdgeInsets.all(4.0),
            child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
              backgroundColor: color,
            ),
          ),
        ],
      ),
    );
  }
}
