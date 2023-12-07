import 'package:flutter/material.dart';
import 'package:news_pbp/pages/register.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/confirm.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();

  void pushConfirmPassword(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmPassword(id: user.id),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Register(),
      ),
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 450,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/forgot.png"),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0), // Add left padding
              child: Text(
                "Forgot",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Password ?",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
              child: Text(
                "Jangan Khawatir Brother & Sister. Masukkan Email Kalian dan kami akan meminta Anda untuk membuat password kalian Kembali.",
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    User user = User(email: emailController.text);
                    try {
                      user = await UserClient.forgotPassword(user);
                      pushConfirmPassword(context, user);
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                backgroundColor:
                                    const Color.fromRGBO(122, 149, 229, 1),
                                title: const Text('Email Tidak Ditemukan !!',
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
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          horizontal: 120.0, vertical: 20.0),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF7A95E6)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
