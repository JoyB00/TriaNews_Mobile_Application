import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/view/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool showPassword = false;
  File? userImage;
  String? image;
  String username = "";
  int id = -1;
  bool isLoading = false;
  Image convert = Image.asset('images/luffy.jpg');
  String? gambar;

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      backgroundColor: const Color.fromRGBO(122, 149, 229, 1),
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 7.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                    ),
                    child: Text(
                      "Foto Profil",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          User user = await UserClient.find(id);
                          user.image = null;
                          setState(() {
                            gambar = user.image;
                          });
                          await UserClient.update(user);
                          Navigator.pop(context);
                        } catch (e) {
                          print("asdas");
                        }
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(122, 149, 229, 1),
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CameraView(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.camera_alt_outlined,
                                    size: 30, color: Colors.white)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: const Text(
                          "Kamera",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, top: 10.0, bottom: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(122, 149, 229, 1),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _getFromGallery(id);
                                },
                                icon: const Icon(Icons.photo_outlined,
                                    size: 30, color: Colors.white),
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 25.0),
                        child: const Text(
                          "Galeri",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id = user.id!;
      username = user.username!;
      usernameController.text = user.username!;
      emailController.text = user.email!;
      passwordController.text = user.password!;
      notelpController.text = user.notelp!;
      dateController.text = user.dateofbirth!;
      image = user.image;
      gambar = user.image;
      if (gambar != null) {
        userImage = File(gambar!);
        convert = Image.file(userImage!);
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65),
          child: Image.asset(
            'images/Tria News.png',
            width: 150,
            height: 200,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 500,
                      height: 220.0,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(122, 149, 229, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: const Text(
                              "My Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showImageOptions();
                            },
                            child: Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.white,
                                  // image: DecorationImage(
                                  //   image: convert.image,
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                child: gambar != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: (convert.image),
                                      )
                                    : const CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage('images/luffy.jpg'),
                                      )),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Nama",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                  controller: usernameController,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Username Baru Anda',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5.0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username tidak boleh kosong';
                                    } else if (value.length < 6) {
                                      return 'Username kurang dari 6 karakter';
                                    }
                                    return null;
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                  controller: emailController,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Email Baru Anda',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5.0,
                                    ),
                                    border: InputBorder.none,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                  controller: passwordController,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Password Baru anda",
                                    border: InputBorder.none,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "No Telepon",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                  controller: notelpController,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'No Telepon Baru Anda',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5.0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.phone,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Tanggal Lahir",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                  controller: dateController,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    hintText: "Input Baru",
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 15.0,
                                    ),
                                    border: InputBorder.none,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 160.0),
                    SizedBox(
                      height: 50.0,
                      width: 350.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await editUser(id);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Berhasil Edit Profile"),
                              ));
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(e.toString()),
                              ));
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(122, 149, 229, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Maaf, Anda harus berusia minimal 17 tahun.'),
        ));
      } else {
        setState(() {
          dateController.text = picked.toString().split(" ")[0];
        });
      }
    }
  }

  _getFromGallery(var id) async {
    // ignore: deprecated_member_use
    String? imageFile;
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = pickedFile.path;
      // imageFile = File(pickedFile.path);
      setState(() {
        gambar = imageFile;
        print('aasdasd ${gambar}');
      });
      editImage(id, imageFile);
    }
  }

  Future<void> editImage(int id, String result) async {
    User temp = await UserClient.find(id);
    User user = temp;
    user.image = result;
    await UserClient.update(user);
  }

  Future<void> editUser(int id) async {
    User user = await UserClient.find(id);
    //User user = temp;
    user.email = emailController.text;
    user.notelp = notelpController.text;
    user.username = usernameController.text;
    user.password = passwordController.text;

    await UserClient.update(user);
  }
}
