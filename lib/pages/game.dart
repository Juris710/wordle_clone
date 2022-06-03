import 'package:flutter/material.dart';
import 'package:wordle_test/ui/guess.dart';
import 'package:wordle_test/ui/keyboard.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
        leading:
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
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
