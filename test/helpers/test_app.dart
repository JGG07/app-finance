import 'package:app_finance/src/app/app.dart';
import 'package:app_finance/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ThemeData get testTheme => AppTheme.dark.copyWith(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );

Widget buildTestApp({
  required Widget child,
  bool scaffold = true,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: testTheme,
    darkTheme: testTheme,
    themeMode: ThemeMode.dark,
    home: scaffold ? Scaffold(body: child) : child,
  );
}

Widget buildFinanceTestApp() {
  return AppFinance(
    enablePersistence: false,
    themeOverride: testTheme,
  );
}

Future<void> scrollToAndTap(
  WidgetTester tester,
  Finder target,
) async {
  final scrollable =
      find.ancestor(of: target, matching: find.byType(Scrollable)).first;
  await tester.dragUntilVisible(
    target,
    scrollable,
    const Offset(0, -300),
  );
  // `dragUntilVisible` can stop with the target underneath the app's bottom
  // navigation bar. Move it into the safe center of the viewport before tap.
  await tester.drag(scrollable, const Offset(0, -180));
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}
