import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/client/UserClient.dart';
// import 'package:news_pbp/View/camera/camera.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key, this.id});
  final int? id;

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
    User user = await UserClient.find(widget.id);
    usernameController.text = user.username!;
    emailController.text = user.email!;
    passwordController.text = user.password!;
    notelpController.text = user.notelp!;
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
          padding: EdgeInsets.only(top: 2.h),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
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
                    "Silahkan Perbarui data anda",
                    style: TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontStyle: FontStyle.italic),
                  ),
                  Padding(padding: EdgeInsets.all(2.h)),
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
                  Padding(padding: EdgeInsets.all(1.h)),
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
                          await editUser();
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

  Future<void> editUser() async {
    User user = User(
      id: widget.id ?? 0,
      email: emailController.text,
      notelp: notelpController.text,
      username: usernameController.text,
      password: passwordController.text,
    );

    await UserClient.update(user);
  }

  //   await SQLHelper.editUser(id, emailController.text, notelpController.text,
  //       usernameController.text, passwordController.text);
  // }
}
