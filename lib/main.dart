import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wordle_clone/constants.dart';
import 'package:wordle_clone/routes.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
        surface: Colors.blueGrey,
      ),
    );
    final textTheme = theme.textTheme;
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialApp.router(
            title: appName,
            theme: theme.copyWith(
              textTheme: GoogleFonts.sawarabiGothicTextTheme(textTheme),
            ),
            routerDelegate: GameRouterDelegate(ref: ref),
            routeInformationParser: GameRouteInformationParser(),
          );
        },
      ),
    );
  }
}
