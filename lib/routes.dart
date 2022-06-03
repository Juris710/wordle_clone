import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_test/pages/game.dart';
import 'package:wordle_test/pages/home.dart';
import 'package:wordle_test/riverpod/misc.dart';
import 'package:wordle_test/words.dart';

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
  final GlobalKey<NavigatorState> _navigatorKey;

  final WidgetRef ref;

  bool isUnknown = false;

  GameRouterDelegate({required this.ref})
      : _navigatorKey = GlobalKey<NavigatorState>() {
    ref.listen(answerProvider, (_, __) => notifyListeners());
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
  Future<void> setNewRoutePath(GameRoutePath configuration) async {
    isUnknown = configuration.isUnknown;
    final answer =
        (configuration.isGamePage) ? words[configuration.answerId] : "";
    ref.read(answerProvider.notifier).state = answer;
  }

  @override
  Widget build(BuildContext context) {
    final answer = ref.watch(answerProvider);
    return Navigator(
      key: _navigatorKey,
      pages: [
        const MaterialPage(child: HomePage()),
        if (isUnknown)
          const MaterialPage(
            child: Scaffold(
              body: Center(
                child: Text("404"),
              ),
            ),
          ),
        if (!isUnknown && answer != "") const MaterialPage(child: GamePage()),
      ],
      onPopPage: (route, result) {
        return (route.didPop(result));
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}

class GameRouteInformationParser extends RouteInformationParser<GameRoutePath> {
  @override
  Future<GameRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");
    if (uri.pathSegments.isEmpty) {
      return GameRoutePath.home();
    }
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != "game") {
        return GameRoutePath.unknown();
      }
      final answerId = int.tryParse(uri.pathSegments[1]);
      if (answerId == null) {
        return GameRoutePath.unknown();
      }
      return GameRoutePath.game(answerId);
    }
    return GameRoutePath.unknown();
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
