// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_test/keyboard.dart';
import 'package:wordle_test/riverpod/guess_input.dart';
import 'package:collection/collection.dart';
void main() {
  group("単体テスト", () {
    test("UIキーボードで全部の文字を入力できる", () {
      final lettersInKeyboard = [
        ...keyboardFirstRowLetters,
        ...keyboardSecondRowLetters,
        ...keyboardThirdRowLetters,
      ];
      lettersInKeyboard.sort();
      expect(const ListEquality().equals(lettersInGuess , lettersInKeyboard), true);
    });
  });
}
