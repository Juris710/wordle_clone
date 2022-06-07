// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_clone/ui/keyboard.dart';
import 'package:wordle_clone/riverpod/guess.dart';
import 'package:collection/collection.dart';
import 'package:wordle_clone/words.dart';
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
    test("辞書の単語の文字数が全て想定された文字数である", (){
      for (final element in words) {
        expect(element.length, guessLength);
      }
    });
  });
}
