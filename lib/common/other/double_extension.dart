import 'dart:math';

extension toString on double {
  /// Returns the double as a string with [n] or less decimal places
  ///
  /// ```
  /// 0.999999999.toStringAsDynamic(2); // '0.99'
  ///
  /// 4.23.toStringAsDynamic(7); // '4.23'
  ///
  /// 2.0000000032.toStringAsDynamic(3); // '2'
  /// ```
  String toStringAsDynamic(int n) {
    double currentNumber = this;
    int tens = pow(10, n) as int;
    currentNumber *= tens;
    currentNumber = currentNumber.floorToDouble();
    bool isInt = currentNumber % tens == 0;
    currentNumber /= tens;
    if (isInt) return currentNumber.floor().toString();
    return currentNumber.toString();
  }
}
