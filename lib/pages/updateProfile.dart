import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:news_pbp/View/camera/camera.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  UpdateProfilePageState createState() => UpdateProfilePageState();
}

class UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();

  bool showPassword = false;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> user =
        await SQLHelper.getUser(prefs.getInt('userId') ?? 0);

    usernameController.text = user[0]['username'];
    emailController.text = user[0]['email'];
    passwordController.text = user[0]['password'];
    notelpController.text = user[0]['notelp'];
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const Text(
                    "Silahkan Perbarui data anda",
                    style: TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontStyle: FontStyle.italic),
                  ),
                  Padding(padding: EdgeInsets.all(3.h)),
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
                  Padding(padding: EdgeInsets.all(3.h)),
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
                  Padding(padding: EdgeInsets.all(3.h)),
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
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 16.0)),
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
                  Padding(padding: EdgeInsets.all(15.h)),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          int id = prefs.getInt('userId') ?? 0;
                          await editUser(id);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Email yang digunakan sudah terdaftar'),
                          ));
                        }
                      }
                    },
                    child: const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> editUser(int id) async {
    await SQLHelper.editUser(id, emailController.text, notelpController.text,
        usernameController.text, passwordController.text);
  }
}
