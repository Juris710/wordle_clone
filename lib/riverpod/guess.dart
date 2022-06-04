import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/hit_blow_state.dart';
import 'package:wordle_clone/riverpod/hit_blow_states.dart';
import 'package:wordle_clone/riverpod/misc.dart';
import 'package:wordle_clone/words.dart';

import '../constants.dart';

const List<String> lettersInGuess = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z"
];

const int guessLength = 5;
const int maxGuessTrialCount = 6;

class GuessInputNotifier extends StateNotifier<String> {
  GuessInputNotifier() : super("");

  void clear() {
    state = "";
  }

  void inputLetter(String letter) {
    if (!lettersInGuess.contains(letter)) {
      return;
    }
    if (state.length == guessLength) {
      return;
    }
    state += letter;
  }

  void backspace() {
    if (state.isNotEmpty) {
      state = state.substring(0, state.length - 1);
    }
  }
}

final guessInputProvider =
    StateNotifierProvider.autoDispose<GuessInputNotifier, String>(
        (ref) => GuessInputNotifier());

Guess generateGuess(String answer, String input) {
  assert(answer.length == guessLength);
  assert(input.length == guessLength);
  final letters = input.split("");
  final hitBlowStates =
      List.generate(guessLength, (index) => HitBlowState.miss);

  final letterHitBlowCounts = <String, int>{};
  // hit判定
  for (int i = 0; i < guessLength; ++i) {
    final letter = input[i];
    if (answer[i] == letter) {
      hitBlowStates[i] = HitBlowState.hit;
      letterHitBlowCounts[letter] = letterHitBlowCounts[letter] ?? 0 + 1;
    }
  }
  // blow判定
  for (int i = 0; i < guessLength; ++i) {
    if (hitBlowStates[i] == HitBlowState.hit) {
      continue;
    }
    final letter = input[i];
    if (!answer.contains(letter)) {
      continue;
    }
    final letterCountsInAnswer = letter.allMatches(answer).length;
    final letterCounts = letterHitBlowCounts[letter] ?? 0;
    if (letterCountsInAnswer == letterCounts) {
      continue;
    }
    assert(letterCountsInAnswer > letterCounts);

    hitBlowStates[i] = HitBlowState.blow;
    letterHitBlowCounts[letter] = letterCounts + 1;
  }

  return Guess(letters, hitBlowStates);
}

class Guess {
  final List<String> letters;
  final List<HitBlowState> hitBlowStates;

  Guess(this.letters, this.hitBlowStates)
      : assert(letters.length == guessLength),
        assert(hitBlowStates.length == guessLength);

  String letterAt(int index) {
    assert(0 <= index && index < guessLength);
    return letters[index];
  }

  HitBlowState hitBlowStateAt(int index) {
    assert(0 <= index && index < guessLength);
    return hitBlowStates[index];
  }

  @override
  String toString() {
    String result = "";
    for (int i = 0; i < guessLength; ++i) {
      result += "${letterAt(i)}:${hitBlowStateAt(i)}, ";
    }
    return result;
  }

  Map<String, HitBlowState> toMap() {
    final map = <String, HitBlowState>{};
    for (int i = 0; i < guessLength; ++i) {
      map[letterAt(i)] = hitBlowStateAt(i);
    }
    return map;
  }

  bool get isClear {
    for (int i = 0; i < guessLength; ++i) {
      if (hitBlowStateAt(i) != HitBlowState.hit) {
        return false;
      }
    }
    return true;
  }
}

class GuessesNotifier extends StateNotifier<List<Guess>> {
  Ref ref;

  GuessesNotifier(this.ref) : super([]);

  String tryAddGuess() {
    final input = ref.read(guessInputProvider);

    if (input.length < guessLength) {
      return "文字数が足りません";
    }
    assert(input.length == guessLength);
    if (!words.contains(input.toLowerCase())) {
      return "辞書に存在しない単語です";
    }
    // FIXME：アニメーション再生中も入力できる
    ref.read(isAnimationPlayingProvider.notifier).state = true;
    final answer = ref.read(answerProvider);
    assert(answer.length == guessLength);
    final guess = generateGuess(answer, input);
    state = [...state, guess];
    Future.delayed(animationDuration, () {
      ref.read(isAnimationPlayingProvider.notifier).state = false;
      ref.read(hitBlowStatesProvider.notifier).update(guess.toMap());
      if (guess.isClear) {
        ref.read(isGameClearProvider.notifier).state = true;
      }
    });
    return "";
  }
}

final guessesNotifierProvider =
    StateNotifierProvider.autoDispose<GuessesNotifier, List<Guess>>(
        (ref) => GuessesNotifier(ref));
