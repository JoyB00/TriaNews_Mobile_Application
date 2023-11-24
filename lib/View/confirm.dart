import 'package:flutter/material.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/view/login.dart';

class ConfirmPassword extends StatefulWidget {
  final int? id;
  const ConfirmPassword({Key? key, this.id});
  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your new password',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'New Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              controller: passwordConfirmController,
              decoration: InputDecoration(
                hintText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await editUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
                    ),
                  );
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text('Confirm Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editUser() async {
    print(widget.id);
    User temp = await UserClient.find(widget.id);
    print(temp.notelp);
    User user = temp;
    user.password = passwordController.text;

    await UserClient.update(user);
  }
}
