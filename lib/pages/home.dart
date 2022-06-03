import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/constants.dart';
import 'package:wordle_clone/riverpod/misc.dart';
import 'package:wordle_clone/words.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appName,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        ref.read(answerProvider.notifier).state =
                            generateAnswer();
                      },
                      child: const Text("プレイ"),
                    ),
                  ),
                  const SizedBox(height: 128),
                  Text(
                    "単語を指定してプレイ",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "単語の番号",
                        hintText: "0以上${words.length - 1}以下の数字を入力"),
                    validator: (value) {
                      final id = int.tryParse(controller.text);
                      if (id == null) {
                        return "数字を入力してください";
                      }
                      if (id < 0) {
                        return "0以上の数字を入力してください";
                      }
                      if (id >= words.length) {
                        return "${words.length - 1}以下の数字を入力してください。";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final id = int.tryParse(controller.text);
                      if (id != null && 0 <= id && id < words.length) {
                        final answer = words[id];
                        ref.read(answerProvider.notifier).state = answer;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("単語が存在しません。"),
                          ),
                        );
                      }
                    },
                    child: const Text("単語を指定してプレイ"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
