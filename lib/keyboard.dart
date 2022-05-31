import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> keyboardFirstRowLetters = [
  "Q",
  "W",
  "E",
  "R",
  "T",
  "Y",
  "U",
  "I",
  "O",
  "P"
];

const List<String> keyboardSecondRowLetters = [
  "A",
  "S",
  "D",
  "F",
  "G",
  "H",
  "J",
  "K",
  "L"
];
const List<String> keyboardThirdRowLetters = [
  "Z",
  "X",
  "C",
  "V",
  "B",
  "N",
  "M"
];

class Keyboard extends StatefulWidget {
  final void Function(String) inputLetter;
  final VoidCallback backspace;
  final VoidCallback enter;

  const Keyboard(
      {Key? key,
      required this.inputLetter,
      required this.backspace,
      required this.enter})
      : super(key: key);

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
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
                      onTap: () {
                        widget.inputLetter(keyName);
                      },
                      keySize: keySize,
                      color: Colors.blueGrey,
                      keyName: keyName,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var keyName in keyboardSecondRowLetters)
                    LetterKeyboardKey(
                      onTap: () {
                        widget.inputLetter(keyName);
                      },
                      keySize: keySize,
                      color: Colors.yellow,
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
                    onTap: widget.enter,
                    child: const Center(
                      child: Text(
                        "Enter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  for (var keyName in keyboardThirdRowLetters)
                    LetterKeyboardKey(
                      onTap: () {
                        widget.inputLetter(keyName);
                      },
                      keySize: keySize,
                      color: Colors.green,
                      keyName: keyName,
                    ),
                  KeyboardKey(
                    keyWidth: keySize * 1.5,
                    keyHeight: keySize,
                    color: Colors.blueGrey,
                    onTap: widget.backspace,
                    child: const Center(
                      child: Icon(
                        Icons.backspace_outlined,
                        color: Colors.white,
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

  bool handleHardwareKeyboard(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return false;
    }
    var letter = event.logicalKey.keyLabel;
    if (letter == "Backspace") {
      widget.backspace();
    } else if (letter == "Enter") {
      widget.enter();
    } else {
      widget.inputLetter(letter);
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
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: color,
            child: child,
          ),
        ),
      ),
    );
  }
}

class LetterKeyboardKey extends StatelessWidget {
  final String keyName;
  final double keySize;
  final Color color;
  final GestureTapCallback onTap;

  const LetterKeyboardKey(
      {Key? key,
      required this.keySize,
      required this.keyName,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardKey(
      onTap: onTap,
      keyWidth: keySize,
      keyHeight: keySize,
      color: color,
      child: Center(
        child: Text(
          keyName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
