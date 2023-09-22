import 'package:flutter/material.dart';
import 'package:news_pbp/component/form_component.dart';
import 'package:news_pbp/main.dart';

class LoginView extends StatefulWidget {
  final Map? data;
  
  const LoginView({super.key, this.data});
  @override
  State <LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State <LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  void pushRegister(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginView(),),
      );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passController = TextEditingController();

    Map? dataForm = widget.data;

    return Scaffold(
      body: SafeArea(
        child:  Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm((p0){
                if (p0 == null||p0.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
                TextEditingController: userController,
                hintTxt: 'Username',
                helperTxt: 'Inputkan user yang telah terdaftar',
                icon: Icons.person,
              ),

              inputForm((p0) {
                if (p0 == null||p0.isEmpty) {
                  return 'Password kosong';
                }
                return null;
              },
                TextEditingController: passController,
                hintTxt: 'Password',
                helperTxt: 'Inputkan password yang telah terdaftar',
                icon: Icons.lock,
                passwordVisible: visible,
                
                suffixIcon: IconButton(
                  icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      visible = !visible;
                      passController.text = passController.text;
                    });
                  },
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                filled: true,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if(dataForm?['username'] != userController.text || dataForm?['password'] != passController.text) {
                            showDialog(context: context, builder: (_) => AlertDialog(
                              title: const Text('Username atau Password salah!'),
                              content: TextButton(
                                onPressed: () => (pushRegister(context)),
                                child: const Text('Daftar Disini'),
                              ),
                              actions: <Widget> [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginView(),),
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
        )
      ),
    );

    
  }
}