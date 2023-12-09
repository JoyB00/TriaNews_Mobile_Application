import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_pbp/pages/register.dart';
import 'package:news_pbp/pages/loginView.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  setUp(() {
    HttpOverrides.global = null;
  });
  testWidgets('Register Page UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ResponsiveSizer(builder: (context, orientation, screenType) {
        return const MaterialApp(
          home: Register(),
        );
      }),
    );
    await tester.enterText(find.byType(TextFormField).at(0), "willjuu");
    await tester.enterText(find.byType(TextFormField).at(1), "will@gmail.com");
    await tester.enterText(find.byType(TextFormField).at(2), "acumalaka");
    await tester.enterText(find.byType(TextFormField).at(3), "acumalaka");
    await tester.enterText(find.byType(TextFormField).at(4), "082121212121");
    await tester.enterText(find.byType(TextFormField).at(5), "06/06/2002");
    await Future.delayed(const Duration(seconds: 4));
    await tester.dragUntilVisible(find.byType(ElevatedButton).first,
        find.byType(SingleChildScrollView), const Offset(521.7, 592.3));
        await Future.delayed(const Duration(seconds: 3));
    await tester.tap(find.byType(Checkbox));
    //expect(tester.widget<Checkbox>(find.byType(Checkbox).at(0)).value, true);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(find.text("Daftar"));
    await tester.pumpAndSettle();
    // expect(find.byType(Builder), findsWidgets);

    await Future.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Daftar").last);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsWidgets);
  });
}  
    
    // expect(find.text('Username'), findsOneWidget);
    // expect(find.text('Email'), findsOneWidget);
    // expect(find.text('Password'), findsOneWidget);
    // expect(find.text('Konfirmasi Password'), findsOneWidget);
    // expect(find.text('Phone Number'), findsOneWidget);
    // expect(find.text('Tanggal Lahir'), findsOneWidget);
    // expect(find.text('Terms Of Service'), findsOneWidget);
    // expect(find.byType(ElevatedButton), findsOneWidget);

    // // Enter some text into the text fields.
    // await tester.enterText(find.byKey(const ValueKey('username')), 'testuser');
    // await tester.enterText(
    //     find.byKey(const ValueKey('email')), 'test@example.com');
    // await tester.enterText(
    //     find.byKey(const ValueKey('password')), 'testpassword');
    // await tester.enterText(
    //     find.byKey(const ValueKey('passwordConfirm')), 'testpassword');
    // await tester.enterText(find.byKey(const ValueKey('notelp')), '1234567890');
    // await tester.tap(find.byKey(const ValueKey('dateofbirth')));
    // await tester.pumpAndSettle();
    // await tester.tap(find.text('OK'));
    // await tester.pumpAndSettle();

    // // Check if the acceptance checkbox is working.
    // expect(find.byType(SnackBar), findsNothing);
    // await tester.tap(find.byType(Checkbox));
    // await tester.pumpAndSettle();
    // expect(
    //     find.text('Anda harus menyetujui Terms of Service.'), findsOneWidget);

    // // Tap the Register button and check if the dialog appears.
    // await tester.tap(find.byType(ElevatedButton));
    // await tester.pumpAndSettle();
    // expect(find.byType(AlertDialog), findsOneWidget);
    // expect(find.text('Konfirmasi'), findsOneWidget);
    // expect(find.text('Apakah data Anda sudah benar?'), findsOneWidget);

    // // Tap the Cancel button in the dialog.
    // await tester.tap(find.text('Cancel'));
    // await tester.pumpAndSettle();
    // expect(find.byType(AlertDialog), findsNothing);

    // // Check if the dialog appears after accepting the checkbox.
    // await tester.tap(find.byType(Checkbox));
    // await tester.pumpAndSettle();
    // await tester.tap(find.byType(ElevatedButton));
    // await tester.pumpAndSettle();
    // expect(find.byType(AlertDialog), findsOneWidget);

    // Tap the Daftar button in the dialog.
    // await tester.tap(find.text('Daftar'));
    // await tester.pumpAndSettle();
    // expect(find.byType(AlertDialog), findsNothing); 
    // await tester.enterText(find.byKey(const Key('username')), 'WilliamJuvent');
    // await tester.enterText(find.byKey(const Key('email')), 'william@gmail.com');
    // await tester.enterText(find.byKey(const Key('password')), 'willjuve');
    // await tester.enterText(find.byKey(const Key('notelp')), '0987654321234');
    // await tester.enterText(find.byKey(const Key('dateofbirth')), '2003-11-23');
    //await tester.tap(find.byKey(const Key('terms')));
    // await Future.delayed(const Duration(seconds: 2));
    // await tester.tap(find.byKey(const Key('register')));
    // await Future.delayed(const Duration(seconds: 2)); 
    // await tester.tap(find.byKey(const Key('daftar')));