import 'package:flutter/material.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/forgotPass.dart';
import 'package:news_pbp/pages/register.dart';
import 'package:news_pbp/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  Future<void> loadUserData(user) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('userId', user.id);
    });
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Register(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void pushForgot(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ForgotPass(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 245, 255, 1),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 480,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/login.png'), fit: BoxFit.cover),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: TextField(
                  controller: userController,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextField(
                  controller: passController,
                  obscureText: visible,
                  onChanged: (value) => setState(() {
                    passController.text = value;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Password',
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
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    pushForgot(context);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(right: 10),
                    ),
                  ),
                  child: const Text('Forgot Password ?'),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User user = User(
                      username: userController.text,
                      password: passController.text,
                    );
                    try {
                      user = await UserClient.login(user);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Login Sukses'),
                      ));

                      loadUserData(user);
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
                                backgroundColor:
                                    const Color.fromRGBO(122, 149, 229, 1),
                                title: const Text(
                                    'Username atau Password salah!',
                                    style: TextStyle(color: Colors.white)),
                                content: SizedBox(
                                  height: 250,
                                  width: 500,
                                  child: Column(children: [
                                    Image.asset(
                                      'images/forgot.png',
                                      height: 200,
                                      width: 500,
                                    ),
                                    const Text('Belum Memiliki Akun ?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const Text('Ayo Daftar Sekarang Juga !!',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFFFFFFF)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () => (pushRegister(context)),
                                    child: const Text('Daftar Disini',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                122, 149, 229, 1))),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ));
                    }
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 150.0),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF7A95E6)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text('Login'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                  ),
                  const Text('Or'),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  pushRegister(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.grey)),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 140.0),
                  ),
                ),
                child:
                    const Text('Sign Up', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
