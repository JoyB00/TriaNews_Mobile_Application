import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/pages/membership.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

void main(){
  setUp(() {
    HttpOverrides.global = null;
  });

  testWidgets("Uang Kurang", (WidgetTester tester) async {
    await tester.pumpWidget(
       const MaterialApp(
        home: MembershipPage(),
      ));

    await tester.tap(find.byType(ElevatedButton).at(0));
    tester.takeException();
    await Future.delayed(const Duration(seconds: 2));
    await tester.enterText(find.byKey(const Key('inputUang')).first, '25000');
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('bayar')));
    await Future.delayed(const Duration(seconds: 2));

    expect(find.byType(Dialog), findsWidgets);
  });
}