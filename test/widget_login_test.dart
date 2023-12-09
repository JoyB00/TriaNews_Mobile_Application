import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/pages/home.dart';
import 'package:news_pbp/pages/loginView.dart';
import 'package:news_pbp/pages/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  setUp(() {
    HttpOverrides.global = null;
  });
  testWidgets("LoginPage success", (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(builder: (context, orientation, screenType) {
        return const MaterialApp(
          home: LoginView(),
        );
      }),
    );

    await tester.enterText(find.byType(TextField).at(0), "Dendy12");
    await tester.enterText(find.byType(TextField).at(1), "12345");

    await tester.dragUntilVisible(find.byType(ElevatedButton).first,
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).at(0));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsWidgets);
  });

  // testWidgets("LoginPage failed", (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ResponsiveSizer(builder: (context, orientation, screenType) {
  //       return const MaterialApp(
  //         home: LoginView(),
  //       );
  //     }),
  //   );

  //   await tester.enterText(find.byType(TextField).at(0), "");
  //   await tester.enterText(find.byType(TextField).at(1), "");
  //   await tester.pumpAndSettle();
  //   await tester.dragUntilVisible(find.byType(ElevatedButton).first,
  //       find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(ElevatedButton).at(0));
  //   await tester.pumpAndSettle();
  //   await Future.delayed(const Duration(seconds: 2));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(Register), findsWidgets);
  // });
}
