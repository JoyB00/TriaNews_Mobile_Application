import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/View/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  TextEditingController notelpController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool showPassword = false;
  bool _isTermsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const Text(
                    "Silahkan Isi Identitas anda",
                    style: TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontStyle: FontStyle.italic),
                  ),
                  Padding(padding: EdgeInsets.all(5.0.w)),
                  TextFormField(
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
                      }),
                  Padding(padding: EdgeInsets.all(1.h)),
                  TextFormField(
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
                  Padding(padding: EdgeInsets.all(1.h)),
                  TextFormField(
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
                            color: showPassword ? Colors.grey : Colors.blue,
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
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0.w, horizontal: 10.0.h)),
                  TextFormField(
                      controller: notelpController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == '') {
                          return 'No hp Tidak Boleh Kosong';
                        } else if (value!.length <= 11) {
                          return 'No Hp tidak boleh kurang dari 11 digit';
                        }
                        return null;
                      }),
                  Padding(padding: EdgeInsets.all(1.h)),
                  TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'Born Date',
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
                      }),
                  Padding(padding: EdgeInsets.all(1.h)),
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
                      const Text('Saya setuju dengan Terms of Service'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isTermsChecked) {
                        _handleRegistration();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Anda harus menyetujui Terms of Service.'),
                        ));
                      }
                    },
                    child: const Text('Daftar Sekarang'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Register Sukses'),
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
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

  Future<void> addUser() async {
    await SQLHelper.addUser(emailController.text, notelpController.text,
        usernameController.text, passwordController.text, _dateController.text);
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {};
      formData['username'] = usernameController.text;
      formData['password'] = passwordController.text;
      _showConfirmationDialog(formData);
    }
  }
}
