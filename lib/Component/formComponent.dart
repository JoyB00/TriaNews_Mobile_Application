import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Padding inputForm(
  Function(String?) validasi, {
  required TextEditingController controller,
  required String hintTxt,
  required String helperTxt,
  required IconData iconData,
  bool isPassword = false,
  bool showPassword = false,
  VoidCallback? toggleObscureText,
  VoidCallback? onTapDatePicker,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 60, top: 5, right: 60),
    child: SizedBox(
        width: 350,
        child: TextFormField(
          validator: (value) => validasi(value),
          autofocus: true,
          controller: controller,
          obscureText: isPassword && !showPassword,
          onTap: onTapDatePicker,
          decoration: InputDecoration(
              hintText: hintTxt,
              border: const OutlineInputBorder(),
              helperText: helperTxt,
              prefixIcon: Icon(iconData),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: toggleObscureText,
                    )
                  : null),
        )),
  );
}
