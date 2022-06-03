import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/riverpod/misc.dart';
import 'package:wordle_test/ui/guess.dart';
import 'package:wordle_test/ui/keyboard.dart';

class GamePage extends HookConsumerWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final answer = ref.read(answerProvider);
      print("answer is $answer");
      return null;
    }, const []);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ref.read(answerProvider.notifier).state = "";
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: GuessesList(),
              ),
            ),
            Keyboard(),
          ],
        ),
      ),
    );
  }
}
