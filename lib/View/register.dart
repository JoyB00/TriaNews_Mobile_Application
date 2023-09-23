import 'package:flutter/material.dart';
import 'package:news_pbp/Component/formComponent.dart';
// import 'package:ugd_1/View/login.dart';

enum Gender { male, female, other }

class Register extends StatefulWidget {
  const Register({Key? key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  Gender _selectedGender = Gender.other;
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
          padding: const EdgeInsets.only(top: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  "Silahkan Isi Identitas anda",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 133, 133, 133),
                      fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                inputForm((p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'username Tidak Boleh Kosong';
                  }
                  return null;
                },
                    controller: usernameController,
                    hintTxt: "Username",
                    helperTxt: "Joel Gans",
                    iconData: Icons.person),
                inputForm((p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Email Tidak Boleh Kosong';
                  }
                  if (!p0.contains('@')) {
                    return 'Email harus menggunakan @';
                  }
                  return null;
                },
                    controller: emailController,
                    hintTxt: "Email",
                    helperTxt: "kelompok3@gmail.com",
                    iconData: Icons.email),
                inputForm(
                    (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Password Tidak Boleh Kosong';
                      }
                      if (p0.length < 5) {
                        return 'Password minimal 5 digit';
                      }
                      return null;
                    },
                    controller: passwordController,
                    hintTxt: 'Password',
                    helperTxt: '*****',
                    iconData: Icons.password,
                    isPassword: true,
                    showPassword: showPassword,
                    toggleObscureText: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
                inputForm((p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Nomor Telepon tidak Boleh kosong';
                  }
                  return null;
                },
                    controller: notelpController,
                    hintTxt: 'No Telp',
                    helperTxt: '081293741834',
                    iconData: Icons.phone_android),
                inputForm(
                  (p0) {
                    if (_dateController.text.isEmpty) {
                      return 'Tannggal Lahir tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: _dateController,
                  hintTxt: 'Tanggal Lahir',
                  helperTxt: '20-09-2003',
                  iconData: Icons.calendar_today,
                  onTapDatePicker: () {
                    _selectDate();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Jenis Kelamin : '),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                    ),
                    Text('Pria'),
                    Radio(
                      value: Gender.male,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    Text('Wanita'),
                    Radio(
                      value: Gender.female,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ],
                ),
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
                    Text('Saya setuju dengan Terms of Service'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedGender == Gender.other) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Pilih Jenis Kelamin kamu'),
                      ));
                    } else if (_isTermsChecked) {
                      _handleRegistration();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2024),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _showConfirmationDialog(Map<String, dynamic> formData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah data Anda sudah benar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Daftar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginView(
                      data: formData,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {};
      formData['username'] = usernameController.text;
      formData['password'] = passwordController.text;
      formData['gender'] = _selectedGender.toString();
      _showConfirmationDialog(formData);
    }
  }
}
