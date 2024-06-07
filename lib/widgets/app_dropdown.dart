import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppDropdown extends StatefulWidget {
  final GlobalKey<FormFieldState<dynamic>>? dropdownState;
  final String? dropdownvalue;
  final String? labelText;
  final List<String>? items;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const AppDropdown({
    Key? key,
    this.dropdownState,
    this.dropdownvalue,
    this.labelText,
    this.items,
    this.top,
    this.bottom,
    this.left,
    this.right,
  }) : super(key: key);

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.dropdownvalue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.left ?? 0.0,
          right: widget.right ?? 0.0,
          top: widget.top ?? 0.0,
          bottom: widget.bottom ?? 0.0),
      child: DropdownButtonFormField(
        key: widget.dropdownState,
        // Initial Value
        value: widget.dropdownvalue,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        dropdownColor: AppTheme.colors.white,
        style: const TextStyle(color: Color(0xff000000)),
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
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Color(0xff000000)),
          hintStyle: const TextStyle(color: Color(0xffB6B7B7)),
        ),

        // Array list of items
        items: widget.items?.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue!;
          });
        },
      ),
    );
  }
}
