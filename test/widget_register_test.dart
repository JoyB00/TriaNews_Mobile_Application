import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/view/register.dart';
import 'package:news_pbp/view/login.dart';

void main() {
  testWidgets('Register Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Register()));

    await tester.enterText(find.byKey(const Key('username')), 'WilliamJuvent');
    await tester.enterText(find.byKey(const Key('password')), 'willjuve');
    await tester.enterText(find.byKey(const Key('notelp')), '0987654321234');
    await tester.enterText(find.byKey(const Key('dateofbirth')), '2003-11-23');
    await tester.tap(find.byType(Checkbox));
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('register')));

    expect(find.byType(LoginView), findsOneWidget);
  });
}
