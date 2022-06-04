import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/colors.dart';
import 'package:wordle_clone/hit_blow_state.dart';
import 'package:wordle_clone/riverpod/hit_blow_states.dart';
import 'package:wordle_clone/riverpod/guess.dart';
import 'package:wordle_clone/riverpod/misc.dart';

const List<String> keyboardFirstRowLetters = [
  "q",
  "w",
  "e",
  "r",
  "t",
  "y",
  "u",
  "i",
  "o",
  "p"
];

const List<String> keyboardSecondRowLetters = [
  "a",
  "s",
  "d",
  "f",
  "g",
  "h",
  "j",
  "k",
  "l"
];
const List<String> keyboardThirdRowLetters = [
  "z",
  "x",
  "c",
  "v",
  "b",
  "n",
  "m"
];

class Keyboard extends ConsumerStatefulWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  ConsumerState<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends ConsumerState<Keyboard> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final smallPadding = constraints.maxWidth < 600;
          final keyWidth = constraints.maxWidth / 10;
          final keyHeight = max(keyWidth, 50.0);
          return Column(
            children: [
              Row(
                children: [
                  for (var keyName in keyboardFirstRowLetters)
                    LetterKeyboardKey(
                      keyWidth: keyWidth,
                      keyHeight: keyHeight,
                      keyName: keyName,
                      smallPadding: smallPadding,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var keyName in keyboardSecondRowLetters)
                    LetterKeyboardKey(
                      keyWidth: keyWidth,
                      keyHeight: keyHeight,
                      keyName: keyName,
                      smallPadding: smallPadding,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KeyboardKey(
                    keyWidth: keyWidth * 1.5,
                    keyHeight: keyHeight,
                    color: backgroundColorNone,
                    smallPadding: smallPadding,
                    onTap: () {
                      final canInput = ref.read(canInputProvider);
                      if (canInput) {
                        enter();
                        return;
                      }
                    },
                    child: const Center(
                      child: Text(
                        "Enter",
                      ),
                    ),
                  ),
                  for (var keyName in keyboardThirdRowLetters)
                    LetterKeyboardKey(
                      keyWidth: keyWidth,
                      keyHeight: keyHeight,
                      keyName: keyName,
                      smallPadding: smallPadding,
                    ),
                  KeyboardKey(
                    keyWidth: keyWidth * 1.5,
                    keyHeight: keyHeight,
                    color: backgroundColorNone,
                    smallPadding: smallPadding,
                    onTap: () {
                      final canInput = ref.read(canInputProvider);
                      if (canInput) {
                        backspace();
                        return;
                      }
                    },
                    child: const Center(
                      child: Icon(
                        Icons.backspace_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void enter() {
    final errorMessage =
        ref.read(guessesNotifierProvider.notifier).tryAddGuess();
    if (errorMessage.isEmpty) {
      ref.read(guessInputProvider.notifier).clear();
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void backspace() {
    ref.read(guessInputProvider.notifier).backspace();
  }

  bool handleHardwareKeyboard(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return false;
    }
    final canInput = ref.read(canInputProvider);
    if (!canInput) {
      return false;
    }
    var letter = event.logicalKey.keyLabel;
    if (letter == "Backspace") {
      backspace();
    } else if (letter == "Enter") {
      enter();
    } else {
      ref.read(guessInputProvider.notifier).inputLetter(letter.toLowerCase());
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(handleHardwareKeyboard);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(handleHardwareKeyboard);
    super.dispose();
  }
}

class KeyboardKey extends StatelessWidget {
  final double keyWidth;
  final double keyHeight;
  final Color color;
  final Widget child;
  final GestureTapCallback onTap;
  final bool smallPadding;

  const KeyboardKey(
      {Key? key,
      required this.keyWidth,
      required this.keyHeight,
      required this.color,
      required this.child,
      required this.onTap,
      required this.smallPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: keyWidth,
      height: keyHeight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: EdgeInsets.all(smallPadding ? 2 : 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 3),
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                color: color,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LetterKeyboardKey extends ConsumerWidget {
  final String keyName;
  final double keyWidth;
  final double keyHeight;
  final bool smallPadding;

  const LetterKeyboardKey({
    Key? key,
    required this.keyWidth,
    required this.keyHeight,
    required this.keyName,
    required this.smallPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hitBlowState =
        ref.watch(hitBlowStatesProvider.select((value) => value[keyName]));
    final color = colorFromHitBlowState(hitBlowState ?? HitBlowState.none);
    return KeyboardKey(
      smallPadding: smallPadding,
      onTap: () {
        final canInput = ref.read(canInputProvider);
        if (canInput) {
          ref.read(guessInputProvider.notifier).inputLetter(keyName);
        }
      },
      keyWidth: keyWidth,
      keyHeight: keyHeight,
      color: color,
      child: Center(
        child: Text(
          keyName.toUpperCase(),
        ),
      ),
    );
  }
}
