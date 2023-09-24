import 'package:flutter/material.dart';

Padding inputForm(Function(String?) validasi, {required TextEditingController,
required String hintTxt, required String helperTxt, required IconData icon, bool passwordVisible = false, IconButton? suffixIcon,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
    child: SizedBox(
      width: 350,
      child: TextFormField(
        controller: TextEditingController,
        validator: (value) => validasi(value),
        autofocus: true,
        obscureText: passwordVisible,
        // onChanged: (value) => ,
        decoration: InputDecoration(
          hintText: hintTxt,
          helperText: helperTxt,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}