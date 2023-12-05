import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/loginView.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool showPassword = false;
  bool visible = false;
  bool _isTermsChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 40.0),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromRGBO(122, 149, 229, 1),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/register.jpg"),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 800.0,
                        width: 380.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color.fromRGBO(238, 245, 255, 0.9),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: const Text(
                                "Selamat Datang",
                                style: TextStyle(
                                  color: Color.fromRGBO(122, 149, 229, 1),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Text(
                              "Silahkan Isi Identitas anda",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Username',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username tidak boleh kosong';
                                    } else if (value.length < 6) {
                                      return 'Username kurang dari 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 10.0, bottom: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      labelText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email Tidak Boleh Kosong';
                                      } else if (!value.contains('@')) {
                                        return 'Email harus Memakai @';
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 10.0, bottom: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      labelText: 'Password',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: showPassword
                                              ? Colors.grey
                                              : Colors.blue,
                                        ),
                                      ),
                                    ),
                                    obscureText: showPassword,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Password tidak boleh kosong';
                                      } else if (value!.length < 5) {
                                        return "password Kurang dari 5 digit";
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 10.0, bottom: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                    controller: passwordConfirmController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      labelText: 'Konfirmasi Password',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: showPassword
                                              ? Colors.grey
                                              : Colors.blue,
                                        ),
                                      ),
                                    ),
                                    obscureText: showPassword,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Password tidak boleh kosong';
                                      } else if (value !=
                                          passwordController.text) {
                                        return "Password tidak sesuai!";
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 10.0, bottom: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                    controller: notelpController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: 'Phone Number',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'No hp Tidak Boleh Kosong';
                                      } else if (value!.length <= 11) {
                                        return 'No Hp tidak boleh kurang dari 11 digit';
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 10.0, bottom: 10.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    labelText: 'Tanggal Lahir',
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 15.0,
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectDate();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tanggal tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isTermsChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isTermsChecked = value!;
                                    });
                                  },
                                ),
                                const Text("I have accepted the"),
                                const Text(
                                  "Terms Of Service",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_isTermsChecked) {
                                  _handleRegistration();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Anda harus menyetujui Terms of Service.'),
                                  ));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF7A95E6)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side:
                                          const BorderSide(color: Colors.grey)),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(horizontal: 120.0),
                                ),
                              ),
                              child: const Text('Daftar',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addUser() async {
    User input = User(
      email: emailController.text,
      notelp: notelpController.text,
      username: usernameController.text,
      password: passwordController.text,
      dateofbirth: _dateController.text,
    );
    await UserClient.create(input);
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      DateTime currentDate = DateTime.now();
      Duration ageDifference = currentDate.difference(picked);
      int userAge = ageDifference.inDays ~/ 365;
      if (userAge < 17) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Maaf, Anda harus berusia minimal 17 tahun.'),
        ));
      } else {
        setState(() {
          _dateController.text = picked.toString().split(" ")[0];
        });
      }
    }
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {};
      formData['username'] = usernameController.text;
      formData['password'] = passwordController.text;
      _showConfirmationDialog(formData);
    }
  }

  Future<void> _showConfirmationDialog(Map<String, dynamic> formData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah data Anda sudah benar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Daftar'),
              onPressed: () async {
                try {
                  await addUser();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Register Sukses'),
                  ));
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
                    ),
                  );
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Email yang digunakan sudah terdaftar'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
