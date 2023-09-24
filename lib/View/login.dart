import 'package:flutter/material.dart';
import 'package:news_pbp/component/form_component.dart';
import 'package:news_pbp/main.dart';

class LoginView extends StatefulWidget {
  final Map? data;

  const LoginView({super.key, this.data});
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
        builder: (_) => const LoginView(),
      ),
    );
  }

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map? dataForm = widget.data;

    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  helperText: 'Masukkan username',
                  prefixIcon: Icon(Icons.person),
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
                  prefixIcon: Icon(Icons.lock),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (dataForm?['username'] != userController.text ||
                          dataForm?['password'] != passController.text) {
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
                            builder: (_) => const LoginView(),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {};
                    formData['username'] = userController.text;
                    formData['password'] = passController.text;
                    pushRegister(context);
                  },
                  child: Text('Daftar akunmu!'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
