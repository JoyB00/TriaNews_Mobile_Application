import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/pages/membership.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  setUp(() {
    HttpOverrides.global = null;
  });

  testWidgets("Uang Kurang", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MembershipPage(),
    ));

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
    // tester.takeException();
    await Future.delayed(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextFormField).at(0), '2500000');
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));
    await tester.dragUntilVisible(find.byType(ElevatedButton).first,
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2));

    expect(find.byType(Dialog), findsWidgets);
  });
}
