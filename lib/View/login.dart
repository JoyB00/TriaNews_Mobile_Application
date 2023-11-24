import 'package:flutter/material.dart';
import 'package:news_pbp/View/home.dart';
import 'package:news_pbp/View/register.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/main.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Register(),
      ),
    );
  }

  // Future<void> loadUserData(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<Map<String, dynamic>> user = await SQLHelper.getUser(id);
  //   setState(() {
  //     prefs.setInt('userId', user[0]['id']);
  //   });
  // }

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User user = User(
                        username: userController.text,
                        password: passController.text,
                      );
                      try {
                        user = await UserClient.login(user);
                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Login Sukses'),
                          ));
                          // loadUserData(user.id ?? 0);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HomePage(id: user.id)),
                          );
                        }
                      } catch (e) {
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

                      // ignore: use_build_context_synchronously
                      // } else {
                      //   // ignore: use_build_context_synchronously
                      //   ScaffoldMessenger.of(context)
                      //       .showSnackBar(const SnackBar(
                      //     content: Text('Login Sukses'),
                      //   ));
                      //   // loadUserData(user.id ?? 0);
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => HomePage(id: user.id)),
                      //   );
                      // }
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
