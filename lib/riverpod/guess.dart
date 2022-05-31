import 'package:hooks_riverpod/hooks_riverpod.dart';

const List<String> allowedLetters = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];

const int _guessLength = 5;

class GuessNotifier extends StateNotifier<String> {
  GuessNotifier() : super("");

  void inputLetter(String letter) {
    if (!allowedLetters.contains(letter)) {
      return;
    }
    if (state.length == _guessLength) {
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

final guessProvider = StateNotifierProvider<GuessNotifier, String>((ref) => GuessNotifier());
