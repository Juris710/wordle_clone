import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/riverpod/guess.dart';

final answerProvider = StateProvider((ref) => "");

final isAnimationPlayingProvider = StateProvider((ref) => false);

final isGameOverProvider = StateProvider.autoDispose((ref) => false);

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
