import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/colors.dart';
import 'package:wordle_test/hit_blow_state.dart';
import 'package:wordle_test/riverpod/guess.dart';

class GuessDisplayLetter extends StatelessWidget {
  final String letter;
  final HitBlowState hitBlowState;

  const GuessDisplayLetter({
    Key? key,
    required this.letter,
    required this.hitBlowState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (hitBlowState) {
      case HitBlowState.hit:
        color = backgroundColorHit;
        break;
      case HitBlowState.blow:
        color = backgroundColorBlow;
        break;
      case HitBlowState.miss:
        color = backgroundColorMiss;
        break;
      default:
        color = backgroundColorNone;
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3),
        ),
        width: 60,
        height: 60,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: color,
          child: Center(
            child: Text(letter),
          ),
        ),
      ),
    );
  }
}

class GuessDisplay extends ConsumerWidget {
  final int guessIndex;

  const GuessDisplay(this.guessIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guesses = ref.watch(guessesNotifierProvider);
    final input = ref.watch(guessInputProvider);
    final List<String> letters = List.generate(guessLength, (index) => "");
    final List<HitBlowState> hitBlowStates =
        List.generate(guessLength, (index) => HitBlowState.none);
    if (guesses.length > guessIndex) {
      final guess = guesses[guessIndex];
      for (int i = 0; i < guessLength; ++i) {
        letters[i] = guess.letterAt(i);
        hitBlowStates[i] = guess.hitBlowStateAt(i);
      }
    } else if (guesses.length == guessIndex) {
      for (int i = 0; i < input.length; ++i) {
        letters[i] = input[i];
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < guessLength; ++i)
          GuessDisplayLetter(
            letter: letters[i],
            hitBlowState: hitBlowStates[i],
          ),
      ],
    );
  }
}

class GuessesList extends StatelessWidget {
  const GuessesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < maxGuessTrialCount; i++) GuessDisplay(i),
      ],
    );
  }
}
