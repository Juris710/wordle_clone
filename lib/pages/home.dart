import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/riverpod/misc.dart';
import 'package:wordle_test/words.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: "0");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(answerProvider.notifier).state = generateAnswer();
                },
                child: const Text("ランダムな単語で開始"),
              ),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  final id = int.parse(controller.text);
                  if (0 <= id && id < words.length) {
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
                child: const Text("単語を指定して開始"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
