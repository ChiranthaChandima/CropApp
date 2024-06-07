import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField(
      {Key? key,
      this.initialValue,
      this.top,
      this.bottom,
      this.left,
      this.right,
      required this.hitText,
      this.obscureText = false,
      this.readOnly = false,
      this.suffixIcon,
      required this.fieldValue, this.validator, this.keyboardType, this.onTap, this.maxLines})
      : super(key: key);

  final String? initialValue;
  final int? maxLines;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final TextInputType? keyboardType;
  final String hitText;
  final TextEditingController fieldValue;
  final bool obscureText;
  final bool readOnly;
  final GestureDetector? suffixIcon;
  final String? Function(dynamic value)? validator;
  final Future<void>? Function()? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.left ?? 0.0, right: widget.right ?? 0.0, top: widget.top ?? 0.0, bottom: widget.bottom ?? 0.0),
      child: TextFormField(
        maxLines: widget.maxLines??1,
        readOnly: widget.readOnly,
        // initialValue: "ss",
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        controller: widget.fieldValue,
        cursorColor: AppTheme.colors.green,
        style: TextStyle(color: AppTheme.colors.grey),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.colors.green),
            borderRadius: BorderRadius.circular(35.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(35.0),
          ),
          border: InputBorder.none,
          hintText: widget.hitText,
          hintStyle: TextStyle(color: AppTheme.colors.grey200),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.colors.green,
                  ),
                )
              : null,
        ),
        validator: widget.validator ?? null
        ,
        obscureText: widget.obscureText ? _obscureText : false,
      ),
    );
  }
}
