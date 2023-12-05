import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news_pbp/main.dart';
import 'package:news_pbp/pages/profileNew.dart';
import 'package:news_pbp/view/home.dart';
import 'package:news_pbp/view/login.dart';
import 'package:news_pbp/view/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  setUp(() {
    HttpOverrides.global = null;
  });
  testWidgets("LoginPage UI Test Success", (WidgetTester tester) async {
    await tester.pumpWidget(
        ResponsiveSizer(builder: (context, orientation, screenType) {
      return const MaterialApp(
        home: LoginView(),
      );
    }));
    await tester.enterText(find.byType(TextField).at(0), "Dendy12");
    await tester.enterText(find.byType(TextField).at(1), "12345");
    await tester.tap(find.byType(ElevatedButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text("Login Sukses"), findsOneWidget);
  });

  // testWidgets('LoginPage UI Test Failed', (WidgetTester tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: MainApp(),
  //   ));
  //   await Future.delayed(const Duration(seconds: 2));
  //   await tester.enterText(find.byKey(const Key("username")), "Invalid");
  //   await Future.delayed(const Duration(seconds: 2));
  //   await tester.enterText(find.byKey(const Key("password")), "Invalid");
  //   await Future.delayed(const Duration(seconds: 2));
  //   await tester.tap(find.byKey(const Key("login")));

  //   await Future.delayed(const Duration(seconds: 2));
  //   await tester.pumpAndSettle();
  //   await Future.delayed(const Duration(seconds: 2));
  // });
}
