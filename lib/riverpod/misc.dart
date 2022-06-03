import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/riverpod/guess.dart';

final answerProvider = StateProvider((ref) => "");

// TODO：アニメーション実装後、前後で値を変える
final isAnimationPlayingProvider = StateProvider.autoDispose((ref) => false);

final isGameOverProvider = Provider.autoDispose((ref) {
  final guesses = ref.watch(guessesNotifierProvider);
  return (guesses.length == maxGuessTrialCount);
});

final isGameClearProvider = StateProvider.autoDispose((ref) => false);

final canInputProvider = Provider.autoDispose((ref) {
  final answer = ref.watch(answerProvider);
  if (answer.isEmpty) {
    return false;
  }
  assert(answer.length == guessLength);
  final isAnimationPlaying = ref.watch(isAnimationPlayingProvider);
  if (isAnimationPlaying) {
    return false;
  }
  final isGameOver = ref.watch(isGameOverProvider);
  if (isGameOver) {
    return false;
  }
  final isGameClear = ref.watch(isGameClearProvider);
  if (isGameClear) {
    return false;
  }
  return true;
});
