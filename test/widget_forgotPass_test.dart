import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/pages/home.dart';
import 'package:news_pbp/pages/loginView.dart';
import 'package:news_pbp/pages/forgotPass.dart';
import 'package:news_pbp/pages/confirm.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  setUp(() {
    HttpOverrides.global = null;
  });
  testWidgets("Forgot Password success", (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(builder: (context, orientation, screenType) {
        return const MaterialApp(
          home: LoginView(),
        );
      }),
    );

    await tester.dragUntilVisible(find.text("Forgot Password ?"),
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.text("Forgot Password ?"));
    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), "joel@gmail.com");

    await tester.dragUntilVisible(find.byType(ElevatedButton),
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.byType(ElevatedButton));
    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), "234567");
    await tester.enterText(find.byType(TextFormField).at(1), "234567");
    await tester.dragUntilVisible(find.byType(ElevatedButton),
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.byType(ElevatedButton));
    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsWidgets);
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
