import 'package:flutter/material.dart';
import 'package:wordle_test/constants.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: const Center(
        child: Text("存在しないページです。"),
      ),
    );
  }
}
