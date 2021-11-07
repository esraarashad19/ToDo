import 'package:flutter/material.dart';

class ReUsableTextFormField extends StatelessWidget {
  final controllerText;
  final onTapImplemnt;
  final hintText;
  final icon;
  final keyboard;
  ReUsableTextFormField({
    @required this.controllerText,
    @required this.icon,
    @required this.keyboard,
    @required this.hintText,
    this.onTapImplemnt,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      controller: controllerText,
      decoration: InputDecoration(
        hoverColor: Colors.teal,
        prefixIcon: Icon(icon),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      onTap: onTapImplemnt,
      validator: (text) {
        if (text.isEmpty) return '$hintText can\'t be null';

        return null;
      },
    );
  }
}
