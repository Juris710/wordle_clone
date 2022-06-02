import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/hit_blow_state.dart';
import 'package:wordle_test/riverpod/misc.dart';
import 'package:wordle_test/words.dart';

const List<String> lettersInGuess = [
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

const int guessLength = 5;
const int maxGuessTrialCount = 6;

class GuessInputNotifier extends StateNotifier<String> {
  GuessInputNotifier() : super("");

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

  for (int i = 0; i < guessLength; ++i) {
    final letter = input[i];
    if (answer[i] == letter) {
      hitBlowStates[i] = HitBlowState.hit;
    } else if (answer.contains(letter)) {
      // TODO：Blow判定法修正
      hitBlowStates[i] = HitBlowState.blow;
    }
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
    for (int i = 0; i < guessLength; ++i){
      result += "${letterAt(i)}:${hitBlowStateAt(i)}, ";
    }
    return result;
  }
}

class GuessesNotifier extends StateNotifier<List<Guess>> {
  StateNotifierProviderRef ref;

  GuessesNotifier(this.ref) : super([]);

  String tryAddGuess() {
    final input = ref.read(guessInputProvider);

    if (input.length < guessLength) {
      return "Not enough letters";
    }
    assert(input.length == guessLength);
    if (!words.contains(input.toLowerCase())) {
      return "Not in word list";
    }
    final answer = ref.read(answerProvider);
    assert(answer.length == guessLength);
    final guess = generateGuess(answer, input);
    print(guess.toString());
    state = [...state, guess];
    return "";
  }
}

final guessesNotifierProvider =
    StateNotifierProvider<GuessesNotifier, List<Guess>>(
        (ref) => GuessesNotifier(ref));
