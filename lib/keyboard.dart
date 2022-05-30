import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  State<Keyboard> createState() => _KeyboardState();
}

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

const List<String> keyboardLetters = [
  ...keyboardFirstRowLetters,
  ...keyboardSecondRowLetters,
  ...keyboardThirdRowLetters,
];
const int maxInputLetters = 5;

class _KeyboardState extends State<Keyboard> {
  String input = "";

  void backspace() {
    if (input.isEmpty) {
      return;
    }
    setState(() {
      input = input.substring(0, input.length - 1);
    });
  }

  void inputLetter(String letter) {
    if (input.length == maxInputLetters) {
      return;
    }
    if (!keyboardLetters.contains(letter)) {
      return;
    }
    setState(() {
      input = input + letter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var keySize = constraints.maxWidth / 10;
          return Column(
            children: [
              Text(input.isNotEmpty ? input : "-"),
              Row(
                children: [
                  for (var keyName in keyboardFirstRowLetters)
                    LetterKeyboardKey(
                      onTap: () {
                        inputLetter(keyName);
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
                        inputLetter(keyName);
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
                    onTap: () {
                      print("Enter");
                    },
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
                        inputLetter(keyName);
                      },
                      keySize: keySize,
                      color: Colors.green,
                      keyName: keyName,
                    ),
                  KeyboardKey(
                    keyWidth: keySize * 1.5,
                    keyHeight: keySize,
                    color: Colors.blueGrey,
                    onTap: backspace,
                    child: const Center(
                      child: Text(
                        "<X",
                        style: TextStyle(color: Colors.white),
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
      backspace();
    } else {
      inputLetter(letter);
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
