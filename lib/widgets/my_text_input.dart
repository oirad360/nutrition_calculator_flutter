import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType {
  Text,
  Number,
  Decimal
}

class MyTextInputFormField extends StatefulWidget {
  const MyTextInputFormField({
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
    this.onSaved,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.counterValueVisibility
  });

  final EdgeInsetsGeometry padding;
  final String? initialValue;
  final InputType? type;
  final Color? errorColor;
  final String label;
  final bool obscureText;
  final InputBorder? border;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final int? counterValueVisibility;

  @override
  State<MyTextInputFormField> createState() => _MyTextInputFormFieldState();
}

class _MyTextInputFormFieldState extends State<MyTextInputFormField> {
  String? _errorMessage;
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Stack(
        children: [
          TextFormField(
            maxLength: widget.maxLength,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.obscureText ? 1 : widget.minLines ?? widget.maxLines,
            initialValue: widget.initialValue,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            validator: (value) {
              String? errorMessage;
              if(widget.validator != null) {
                errorMessage = widget.validator!(value);
              }
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
            keyboardType: widget.type == InputType.Number ? TextInputType.number :
                          widget.type == InputType.Decimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
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
              ),
              counter: const Offstage()
            ),
          ),
          if (widget.maxLength != null && _value != null && _value!.length >= (widget.counterValueVisibility ?? (widget.maxLength! / 2))) Positioned(
            top: 11,
            right: 11,
            child: Text('${_value?.length}/${widget.maxLength}', style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 12))
          )
        ],
      ),
    );
  }
}
