import 'package:flutter/material.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/loginView.dart';

class ConfirmPassword extends StatefulWidget {
  final int? id;
  const ConfirmPassword({Key? key, this.id}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  bool visible2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF7A95E6), size: 40.0),
        backgroundColor: const Color.fromRGBO(239, 245, 255, 1),
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromRGBO(239, 245, 255, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 450,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Confirm.png"),
                ),
              ),
            ),
            const Text(
              "VERIFICATION",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
              child: Text(
                "Make sure you remember the new password and don’t share it with anyone else",
                style: TextStyle(fontSize: 15.0, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: TextFormField(
                        controller: passwordController,
                        obscureText: visible,
                        onChanged: (value) => setState(() {
                              passwordController.text = value;
                            }),
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              !visible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                visible = !visible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Password tidak boleh kosong';
                          } else if (value!.length < 5) {
                            return "password Kurang dari 5 digit";
                          }
                          return null;
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: TextFormField(
                        controller: passwordConfirmController,
                        obscureText: visible2,
                        onChanged: (value) => setState(() {
                              passwordConfirmController.text = value;
                            }),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              !visible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                visible2 = !visible2;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Password tidak boleh kosong';
                          } else if (value != passwordController.text) {
                            return "password tidak sesuai";
                          }
                          return null;
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await editUser();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginView(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Gagal Ganti Password'),
                            ));
                          }
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 140.0, vertical: 20.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF7A95E6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: const Text('Verification'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> editUser() async {
    print(widget.id);
    User temp = await UserClient.find(widget.id);
    User user = temp;
    user.password = passwordController.text;

    await UserClient.update(user);
  }
}
