import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/pages/game.dart';
import 'package:wordle_clone/pages/home.dart';
import 'package:wordle_clone/pages/unknown.dart';
import 'package:wordle_clone/riverpod/misc.dart';
import 'package:wordle_clone/words.dart';

const answerIdHome = -1;
const answerIdUnknown = -2;

class GameRoutePath {
  final int answerId;
  final bool isUnknown;

  GameRoutePath.home()
      : answerId = answerIdHome,
        isUnknown = false;

  GameRoutePath.game(this.answerId) : isUnknown = (answerId >= words.length);

  GameRoutePath.unknown()
      : isUnknown = true,
        answerId = answerIdUnknown;

  bool get isHomePage => answerId == answerIdHome;

  bool get isGamePage => answerId >= 0;
}

class GameRouterDelegate extends RouterDelegate<GameRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<GameRoutePath> {
  final WidgetRef ref;

  bool isUnknown = false;

  GameRouterDelegate({required this.ref}) {
    ref.listen(answerProvider, (_, answer) {
      if (answer != "") {
        print("answer is $answer");
      }
      notifyListeners();
    });
  }

  @override
  GameRoutePath get currentConfiguration {
    if (isUnknown) {
      return GameRoutePath.unknown();
    }
    final answer = ref.read(answerProvider);
    if (answer == "") {
      return GameRoutePath.home();
    }
    final answerId = words.indexOf(answer);
    return GameRoutePath.game(answerId);
  }

  @override
  Future<void> setNewRoutePath(GameRoutePath configuration) {
    isUnknown = configuration.isUnknown;
    final answer =
        (configuration.isGamePage) ? words[configuration.answerId] : "";
    ref.read(answerProvider.notifier).state = answer;
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    final answer = ref.watch(answerProvider);
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(key: ValueKey("Home"), child: HomePage()),
        if (isUnknown)
          const MaterialPage(
            key: ValueKey("Unknown"),
            child: UnknownPage(),
          ),
        if (!isUnknown && answer != "")
          MaterialPage(key: ValueKey("game-$answer"), child: const GamePage()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        isUnknown = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class GameRouteInformationParser extends RouteInformationParser<GameRoutePath> {
  @override
  Future<GameRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");
    if (uri.pathSegments.isEmpty) {
      return GameRoutePath.home();
    }
    if (uri.pathSegments[0] != "game") {
      return GameRoutePath.unknown();
    }
    if (uri.pathSegments.length == 2) {
      final answerId = int.tryParse(uri.pathSegments[1]);
      if (answerId != null) {
        return GameRoutePath.game(answerId);
      }
    }
    return GameRoutePath.game(Random().nextInt(words.length));
  }

  @override
  RouteInformation restoreRouteInformation(GameRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: "/404");
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: "/");
    }
    if (configuration.isGamePage) {
      return RouteInformation(location: "/game/${configuration.answerId}");
    }
    return const RouteInformation(location: "/404");
  }
}
