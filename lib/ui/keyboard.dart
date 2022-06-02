import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/colors.dart';
import 'package:wordle_test/hit_blow_state.dart';
import 'package:wordle_test/riverpod/hit_blow_states.dart';
import 'package:wordle_test/riverpod/guess.dart';
import 'package:wordle_test/riverpod/misc.dart';

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
          var keySize = constraints.maxWidth / 10;
          return Column(
            children: [
              Row(
                children: [
                  for (var keyName in keyboardFirstRowLetters)
                    LetterKeyboardKey(
                      keySize: keySize,
                      keyName: keyName,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var keyName in keyboardSecondRowLetters)
                    LetterKeyboardKey(
                      keySize: keySize,
                      keyName: keyName,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KeyboardKey(
                    keyWidth: keySize * 1.5,
                    keyHeight: keySize,
                    color: Colors.blueGrey,
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
                      keySize: keySize,
                      keyName: keyName,
                    ),
                  KeyboardKey(
                    keyWidth: keySize * 1.5,
                    keyHeight: keySize,
                    color: Colors.blueGrey,
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

  const KeyboardKey(
      {Key? key,
      required this.keyWidth,
      required this.keyHeight,
      required this.color,
      required this.child,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: keyWidth,
      height: keyHeight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey, width: 3),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
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
  final double keySize;

  const LetterKeyboardKey(
      {Key? key, required this.keySize, required this.keyName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hitBlowState =
        ref.watch(hitBlowStatesProvider.select((value) => value[keyName]));
    final color = colorFromHitBlowState(hitBlowState ?? HitBlowState.none);
    return KeyboardKey(
      onTap: () {
        final canInput = ref.read(canInputProvider);
        if (canInput) {
          ref.read(guessInputProvider.notifier).inputLetter(keyName);
        }
      },
      keyWidth: keySize,
      keyHeight: keySize,
      color: color,
      child: Center(
        child: Text(
          keyName.toUpperCase(),
        ),
      ),
    );
  }
}
