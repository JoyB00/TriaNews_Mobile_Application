import 'package:flutter/material.dart';
import 'package:news_pbp/View/home.dart';
import 'package:news_pbp/View/register.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:news_pbp/main.dart';
import 'package:news_pbp/database/sql_helper.dart';

class LoginView extends StatefulWidget {
  //Future<List<Map<String, dynamic>>>? data = SQLHelper.getUser();
  //LoginView({super.key, this.data});
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

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //List<Map<String, dynamic>>? dataForm = widget.data;

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
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  helperText: 'Masukkan username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                    borderRadius: BorderRadius.circular(10),
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
                      // dataForm?['username'] != userController.text ||
                      //dataForm?['password'] != passController.text
                      var user = await SQLHelper.loginUser(
                          userController.text, passController.text);
                      if (user.isEmpty) {
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
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(
                              user: user[0],
                            ),
                          ),
                        );
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
