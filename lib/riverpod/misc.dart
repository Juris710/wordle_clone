import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/riverpod/guess.dart';

final answerProvider = StateProvider((ref) => "");

final isAnimationPlayingProvider = StateProvider((ref) => false);

final canInputProvider = Provider((ref) {
  final answer = ref.watch(answerProvider);
  if (answer.isEmpty) {
    return false;
  }
  assert(answer.length == guessLength);
  final isAnimationPlaying =ref.watch(isAnimationPlayingProvider);
  return !isAnimationPlaying;
});
