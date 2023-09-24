
import 'package:news_pbp/View/login.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      //debugShowFloatingThemeButton: true, // <------ add this line
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: LoginView(),
      ),
    );
  }
}
