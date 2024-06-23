import 'package:flutter/material.dart';

class MyDropdownButtonFormField extends StatefulWidget {
  const MyDropdownButtonFormField({
    super.key,
    required this.dropDownList,
    required this.onChanged,
    this.validator,
    this.initialValue,
    this.border,
    this.fillColor,
    this.errorColor,
    this.padding = const EdgeInsets.only(bottom: 10)
  });

  final EdgeInsetsGeometry padding;
  final List<DropdownMenuItem> dropDownList;
  final String? Function(dynamic)? validator;
  final void Function(dynamic) onChanged;
  final dynamic initialValue;
  final InputBorder? border;
  final Color? fillColor;
  final Color? errorColor;

  @override
  State<MyDropdownButtonFormField> createState() => _MyDropdownButtonFormFieldState();
}

class _MyDropdownButtonFormFieldState extends State<MyDropdownButtonFormField> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: DropdownButtonFormField(
        items: widget.dropDownList,
        value: widget.initialValue,
        onChanged: widget.onChanged,
        validator: (value) {
          String? errorMessage = widget.validator!(value);
          setState(() {
            _errorMessage = errorMessage;
          });
          return errorMessage;
        },
        decoration: InputDecoration(
            border: widget.border ?? UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: widget.fillColor ?? Theme.of(context).colorScheme.secondary,
            labelStyle: TextStyle(color: _errorMessage == null ? Theme.of(context).colorScheme.tertiary : Colors.red),
            errorStyle: TextStyle(color: widget.errorColor ?? Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}