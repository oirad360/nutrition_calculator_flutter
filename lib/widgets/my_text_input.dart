import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType {
  Text,
  Number,
  Decimal
}

class MyTextInput extends StatefulWidget {
  MyTextInput({
    super.key,
    required this.label,
    this.obscureText = false,
    this.padding = const EdgeInsets.only(bottom: 10),
    this.type,
    this.initialValue,
    this.errorColor,
    this.border,
    this.fillColor,
    this.validator,
    this.onSaved});

  final EdgeInsetsGeometry padding;
  final String? initialValue;
  final InputType? type;
  final Color? errorColor;
  final String label;
  final bool obscureText;
  final InputBorder? border;
  final Color? fillColor;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        initialValue: widget.initialValue,
        validator: (value) {
          String? errorMessage = widget.validator!(value);
          setState(() {
            _errorMessage = errorMessage;
          });
          return errorMessage;
        },
        onSaved:  widget.onSaved,
        obscureText: widget.obscureText,
        textInputAction: TextInputAction.next,
        cursorColor: Theme.of(context).colorScheme.tertiary,
        cursorErrorColor: Colors.red,
        keyboardType: widget.type == InputType.Number ? TextInputType.number : widget.type == InputType.Decimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        inputFormatters: widget.type == InputType.Number ?
        <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ] :
        widget.type == InputType.Decimal ?
        <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
        ] : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? Theme.of(context).colorScheme.secondary,
          label: Text(widget.label),
          labelStyle: TextStyle(color: _errorMessage == null ? Theme.of(context).colorScheme.tertiary : Colors.red),
          errorStyle: TextStyle(color: widget.errorColor ?? Theme.of(context).colorScheme.secondary),
          border: widget.border ?? UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )
        ),
      ),
    );
  }
}
