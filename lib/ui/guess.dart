import 'package:flutter/material.dart';
import 'package:wordle_test/colors.dart';
import 'package:wordle_test/hit_blow_state.dart';

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

class GuessDisplay extends StatelessWidget {
  const GuessDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        GuessDisplayLetter(
          letter: "H",
          hitBlowState: HitBlowState.none,
        ),
        GuessDisplayLetter(
          letter: "E",
          hitBlowState: HitBlowState.hit,
        ),
        GuessDisplayLetter(
          letter: "L",
          hitBlowState: HitBlowState.blow,
        ),
        GuessDisplayLetter(
          letter: "L",
          hitBlowState: HitBlowState.hit,
        ),
        GuessDisplayLetter(
          letter: "O",
          hitBlowState: HitBlowState.none,
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
      children: [for (int i = 0; i < 5; i++) const GuessDisplay()],
    );
  }
}
