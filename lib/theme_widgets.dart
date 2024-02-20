import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mob_dev/pages/settings.dart';

Widget themedButton(BuildContext context, String text, VoidCallback onPressed) {
  if (currentTheme == ThemeStyle.material) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  } else {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}


Widget themedTextField({required TextEditingController controller, required String placeholder}) {
  if (currentTheme == ThemeStyle.material) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
    );
  } else {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
    );
  }
}


Widget themedProgressIndicator() {
  if (currentTheme == ThemeStyle.material) {
    return CircularProgressIndicator();
  } else {
    return CupertinoActivityIndicator();
  }
}