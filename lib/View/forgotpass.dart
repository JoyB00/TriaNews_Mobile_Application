import 'package:flutter/material.dart';
import 'package:news_pbp/View/confirm.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/client/UserClient.dart';

class ForgotPassword extends StatefulWidget {
  final int? id;
  const ForgotPassword({Key? key, this.id});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  void pushConfirmPassword(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmPassword(id: user.id),
      ),
    );
  }

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepPurple,
        title: const Text('Forgot Password', selectionColor: Colors.amber),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 2.0,
              ),
              Image.asset('images/forgot.png', height: 500),
              const Text(
                'Enter your email to reset password',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  User user = User(email: emailController.text);
                  try {
                    user = await UserClient.forgotPassword(user);
                    print(user.id);
                    pushConfirmPassword(context, user);
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
