import 'package:flutter/material.dart';
import 'package:wordle_clone/constants.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("404", style: textTheme.headline1),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "存在しないページです",
                  style: textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("ホーム画面に戻る"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
