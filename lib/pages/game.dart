import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/constants.dart';
import 'package:wordle_clone/riverpod/misc.dart';
import 'package:wordle_clone/ui/guess.dart';
import 'package:wordle_clone/ui/keyboard.dart';

class GamePage extends ConsumerWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        leading: IconButton(
          onPressed: () async {
            final isGameClear = ref.read(isGameClearProvider);
            final isGameOver = ref.read(isGameOverProvider);
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            if (isGameClear || isGameOver) {
              scaffoldMessenger.removeCurrentSnackBar();
              ref.read(answerProvider.notifier).state = "";
              return;
            }
            await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("確認"),
                    content: const Text("ゲームを終了してもよろしいですか？\nゲームの状態は保存されません。"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("キャンセル"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          scaffoldMessenger.removeCurrentSnackBar();
                          ref.read(answerProvider.notifier).state = "";
                        },
                        child: const Text("終了"),
                      ),
                    ],
                  );
                });
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
