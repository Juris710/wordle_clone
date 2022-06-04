import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/colors.dart';
import 'package:wordle_clone/hit_blow_state.dart';
import 'package:wordle_clone/riverpod/guess.dart';
import 'package:wordle_clone/riverpod/hit_blow_states.dart';
import 'package:wordle_clone/riverpod/misc.dart';

class GuessDisplay extends HookConsumerWidget {
  final int guessIndex;

  const GuessDisplay(this.guessIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useAnimationController(duration: const Duration(seconds: 3));
    ref.listen<Guess>(guessDisplayContentProvider(guessIndex), (prev, next) {
      if (next
          .toGuessLetterList()
          .every((element) => element.hitBlowState != HitBlowState.none)) {
        controller.forward().then((value) {
          ref.read(isAnimationPlayingProvider.notifier).state = false;
          ref.read(hitBlowStatesProvider.notifier).doUpdate();

          if (next.isClear) {
            ref.read(isGameClearProvider.notifier).state = true;
          }
        });
      }
    });
    final guess = ref.watch(guessDisplayContentProvider(guessIndex));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < guessLength; ++i)
          GuessDisplayLetter(
            letter: guess.letterAt(i),
            color: colorFromHitBlowState(guess.hitBlowStateAt(i)),
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  i / (guessLength + 3),
                  (i + 4) / (guessLength + 3),
                  curve: Curves.easeInOutSine,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class GuessDisplayLetter extends AnimatedWidget {
  final String letter;
  final Color color;

  const GuessDisplayLetter({
    Key? key,
    required Animation<double> animation,
    required this.letter,
    required this.color,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3),
        ),
        width: 60,
        height: 60,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX((1 - (animation.value - 0.5).abs() * 2) * pi / 2),
          child: Container(
            color: animation.value < 0.5 ? backgroundColorNone : color,
            child: Center(
              child: Text(letter.toUpperCase()),
            ),
          ),
        ),
      ),
    );
  }
}

class GuessesList extends ConsumerWidget {
  const GuessesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isGameClearProvider, (previous, next) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("CLEAR!"),
        duration: Duration(days: 1),
      ));
    });
    ref.listen(isGameOverProvider, (previous, next) {
      final answer = ref.read(answerProvider);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(answer),
        duration: const Duration(days: 1),
      ));
    });
    return Column(
      children: [
        for (int i = 0; i < maxGuessTrialCount; i++) GuessDisplay(i),
      ],
    );
  }
}
