import 'package:flutter_test/flutter_test.dart';
import 'package:video_game_wish_list/common/double_extension.dart';

void main() {
  group('double with N decimals', () {
    test('big double with 2 decimals', () {
      expect(99.999999999.toStringAsDynamic(2), '99.99');
    });

    test('small double with 7 digits', () {
      expect(99.99.toStringAsDynamic(7), '99.99');
    });
  });
}
