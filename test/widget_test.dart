// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_clone/hit_blow_state.dart';
import 'package:wordle_clone/ui/keyboard.dart';
import 'package:wordle_clone/riverpod/guess.dart';
import 'package:collection/collection.dart';
import 'package:wordle_clone/words.dart';
void main() {
  group("文字の検証", () {
    test("入力可能な文字に被りがない", (){
      expect(lettersInGuess.toSet().length, lettersInGuess.length);
    });
    test("UIキーボードで全部の文字を入力できる", () {
      final lettersInKeyboard = [
        ...keyboardFirstRowLetters,
        ...keyboardSecondRowLetters,
        ...keyboardThirdRowLetters,
      ];
      lettersInKeyboard.sort();
      expect(
          const ListEquality().equals(lettersInGuess, lettersInKeyboard), true);
    });
  });
  group("辞書の検証", () {
    test("辞書の単語の文字数が全て想定された文字数である", (){
      for (final word in words) {
        expect(word.length, guessLength);
      }
    });
    test("辞書の単語全てが入力可能な文字のみで構成されている", (){
      for (final word in words){
        for (var i = 0; i < word.length; ++i){
          expect(lettersInGuess.contains(word[i]), true);
        }
      }
    });
  });
  group("辞書の検証", () {
    test("辞書の単語の文字数が全て想定された文字数である", () {
      for (final word in words) {
        expect(word.length, guessLength);
      }
    });
    test("辞書の単語全てが入力可能な文字のみで構成されている", () {
      for (final word in words) {
        for (var i = 0; i < word.length; ++i) {
          expect(lettersInGuess.contains(word[i]), true);
        }
      }
    });
  });
  group("正誤判定", () {
    test("正解の文字が一つも含まれていないと全てmissになる", () {
      final answer = lettersInGuess.sublist(0, guessLength).join("");
      final input = lettersInGuess.sublist(guessLength, guessLength * 2).join("");
      final guess = generateGuess(answer, input);
      for(var i = 0; i < guessLength; ++i){
        expect(guess.letterAt(i), input[i]);
        expect(guess.hitBlowStateAt(i), HitBlowState.miss);
      }
    });
    test("正解の文字が違う位置に含まれているとblowになる", () {
      final answer = lettersInGuess.sublist(0, guessLength).join("");
      final input = lettersInGuess.sublist(guessLength - 1, guessLength * 2 - 1).join("");
      final guess = generateGuess(answer, input);
      expect(guess.letterAt(0), input[0]);
      expect(guess.hitBlowStateAt(0), HitBlowState.blow);
      for(var i = 1; i < guessLength; ++i){
        expect(guess.letterAt(i), input[i]);
        expect(guess.hitBlowStateAt(i), HitBlowState.miss);
      }
    });
    test("正解の文字が同じ位置に含まれているとhitになる", () {
      final answer = lettersInGuess.sublist(0, guessLength).join("");
      final input = answer[0] + lettersInGuess.sublist(guessLength, guessLength * 2 - 1).join("");
      final guess = generateGuess(answer, input);
      expect(guess.letterAt(0), input[0]);
      expect(guess.hitBlowStateAt(0), HitBlowState.hit);
      for(var i = 1; i < guessLength; ++i){
        expect(guess.letterAt(i), input[i]);
        expect(guess.hitBlowStateAt(i), HitBlowState.miss);
      }
    });
    test("正解の文字と一致していると全てhitになる", () {
      final answer = lettersInGuess.sublist(0, guessLength).join("");
      final input = answer;
      final guess = generateGuess(answer, input);
      for(var i = 0; i < guessLength; ++i){
        expect(guess.letterAt(i), input[i]);
        expect(guess.hitBlowStateAt(i), HitBlowState.hit);
      }
    });
  });
}
