import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText; 
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const InputField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _isObscure; 

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; 
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure; 
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
