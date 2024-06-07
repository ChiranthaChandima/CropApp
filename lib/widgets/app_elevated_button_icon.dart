import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

class AppElevatedButtonIcon extends StatefulWidget {
  final void Function() onPressed;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? fontSize;
  final double? width;
  final double? borderRadius;
  final String title;
  final Color primary;
  final Color onPrimary;
  final FaIcon icon;
  final TextDirection? textDirection;

  const AppElevatedButtonIcon({
    Key? key,
    required this.onPressed,
    required this.title,
    this.top,
    this.left,
    this.right,
    this.fontSize,
    this.bottom,
    this.textDirection,
    this.width,
    this.borderRadius,
    required this.primary,
    required this.onPrimary,
    required this.icon,
  }) : super(key: key);

  @override
  State<AppElevatedButtonIcon> createState() => _AppElevatedButtonIconState();
}

class _AppElevatedButtonIconState extends State<AppElevatedButtonIcon> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
          left: widget.left ?? 0.0,
          right: widget.right ?? 0.0,
          top: widget.top ?? 0.0,
          bottom: widget.bottom ?? 0.0),
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        // height: double.infinity,
        child: Directionality(
          textDirection: widget.textDirection ?? TextDirection.ltr,
          child: ElevatedButton.icon(
              icon: widget.icon,
              label: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: widget.fontSize ?? 15,
                      color: AppTheme.colors.white)),
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 17.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 35.0),
                ),
                primary: widget.primary,
                onPrimary: widget.onPrimary,
              )),
        ),
      ),
    );
  }
}
