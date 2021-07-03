import 'dart:math';

extension toString on double {
  String toStringAsDynamic(int n) {
    double currentNumber = this;
    int tens = pow(10, n) as int;
    currentNumber *= tens;
    currentNumber = currentNumber.floorToDouble();
    currentNumber /= tens;
    return currentNumber.toString();
  }
}
