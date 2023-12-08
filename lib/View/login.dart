import 'package:flutter/material.dart';
import 'package:news_pbp/View/home.dart';
import 'package:news_pbp/View/register.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/main.dart';
import 'package:news_pbp/view/forgotpass.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  String temp = "";
  void pushRegister(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return Register();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void pushForgotPassword(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ForgotPassword();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _showToast() {
    toastification.show(
      context: context,
      autoCloseDuration: const Duration(seconds: 3),
      title: 'Selamat Datang',
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: Icon(Icons.check),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      brightness: Brightness.light,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      showProgressBar: true,
      showCloseButton: true,
      closeOnClick: false,
      pauseOnHover: true,
    );
  }

  Future<void> loadUserData(user) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('userId', user.id);
    });
  }

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //change theme
            FloatingActionButton(
              onPressed: () {
                changeTheme(AdaptiveTheme.of(context).mode, context);
              },
              child: const Icon(Icons.lightbulb),
            ),
            Padding(
              padding: EdgeInsets.all(2.0.h),
              child: TextField(
                key: const ValueKey("username"),
                controller: userController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  helperText: 'Masukkan username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.0.h),
              child: TextField(
                key: const ValueKey("password"),
                controller: passController,
                obscureText: visible,
                onChanged: (value) => setState(() {
                  passController.text = value;
                }),
                decoration: InputDecoration(
                  hintText: 'Password',
                  helperText: 'Masukkan password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                pushForgotPassword(context);
              },
              child: Text('Forgot Password?'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  key: const ValueKey("login"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User user = User(
                        username: userController.text,
                        password: passController.text,
                      );
                      try {
                        user = await UserClient.login(user);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Login Sukses'),
                        ));
                        // loadUserData(user);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomePage(id: user.id)),
                        );
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text(
                                      'Username atau Password salah!'),
                                  content: TextButton(
                                    onPressed: () => (pushRegister(context)),
                                    child: const Text('Daftar Disini'),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ));
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {};
                    formData['username'] = userController.text;
                    formData['password'] = passController.text;
                    pushRegister(context);
                  },
                  child: const Text('Daftar akunmu!'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
