import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_pbp/pages/loginView.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
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

      return AdaptiveTheme(
        light: ThemeData.light(),
        dark: ThemeData.dark(),
        debugShowFloatingThemeButton: true, // <------ add this line
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: const LoginView(),
        ),
      );
    });
  }
}

//theme mode changer
void changeTheme(AdaptiveThemeMode adaptiveThemeMode, BuildContext context) {
  if (adaptiveThemeMode == AdaptiveThemeMode.light) {
    AdaptiveTheme.of(context).setDark();
  } else {
    AdaptiveTheme.of(context).setLight();
  }
}
