import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/database/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const UpdateProfilePage({super.key, required this.user});

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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = widget.user;
    usernameController.text = user['username'];
    emailController.text = user['email'];
    passwordController.text = user['password'];
    notelpController.text = user['notelp'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const Text(
                    "Silahkan Perbarui data anda",
                    style: TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontStyle: FontStyle.italic),
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                          hintText: 'asdasd'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username tidak boleh kosong';
                        } else if (value.length < 6) {
                          return 'Username kurang dari 6 karakter';
                        }
                        return null;
                      }),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Tidak Boleh Kosong';
                        } else if (value.length < 6) {
                          return 'Email harus Memakai @';
                        }
                        return null;
                      }),
                  const Padding(padding: EdgeInsets.all(5.0)),
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
                  const Padding(padding: EdgeInsets.all(30.0)),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await editUser(user['id']);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString('userNama', usernameController.text);
                          prefs.setString('userNoTelp', notelpController.text);
                          prefs.setString('userPass', passwordController.text);
                          prefs.setString('userEmail', emailController.text);
                        });
                        Navigator.pop(context);
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
