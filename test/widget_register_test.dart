import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/view/register.dart';
import 'package:news_pbp/view/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('Register Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(ResponsiveSizer(
        builder: (context, orientation, screenType) {
          Device.orientation == Orientation.portrait
              ? Container(
                  width: 100.w,
                  height: 20.5.h,
                )
              : Container(
                  width: 100.w,
                  height: 12.5.h,
                );
          Device.screenType == ScreenType.tablet
          ? Container(
              width: 100.w,
              height: 20.5.h,
            )
          : Container(
              width: 100.w,
              height: 12.5.h,
            );
          return const MaterialApp(home: Register());
        }
      ));

    await tester.enterText(find.byKey(const Key('username')), 'WilliamJuvent');
    await tester.enterText(find.byKey(const Key('email')), 'william@gmail.com');
    await tester.enterText(find.byKey(const Key('password')), 'willjuve');
    await tester.enterText(find.byKey(const Key('notelp')), '0987654321234');
    await tester.enterText(find.byKey(const Key('dateofbirth')), '2003-11-23');
    //await tester.tap(find.byKey(const Key('terms')));
    await Future.delayed(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('register')));
    await Future.delayed(const Duration(seconds: 2)); 
    await tester.tap(find.byKey(const Key('daftar')));

    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });
}
