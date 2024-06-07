import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppElevatedButton extends StatefulWidget {
  final void Function() onPressed;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final String title;
  final Color primary;
  final Color onPrimary;
  final Color? borderColor;
  final Color? fontColor;
  final double? borderRadius;

  const AppElevatedButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.top,
    this.left,
    this.right,
    this.borderColor,
    this.fontColor,
    this.bottom,
    required this.primary,
    this.borderRadius,
    required this.onPrimary,
  }) : super(key: key);

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.left ?? 0.0,
          right: widget.right ?? 0.0,
          top: widget.top ?? 0.0,
          bottom: widget.bottom ?? 0.0),
      alignment: Alignment.center,
      child: ElevatedButton(
          child: Center(
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: widget.fontColor))),
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: widget.borderColor ?? widget.primary, width: 2),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 35.0),
            ),
            primary: widget.primary,
            onPrimary: widget.onPrimary,
          )),
    );
  }
}
