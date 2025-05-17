import 'package:flutter/material.dart';
import '../../../core/constants/constant_string.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final double width;
  final double height;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.width = double.infinity,
    this.height = 50,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  CustomInputState createState() => CustomInputState();
}

class CustomInputState extends State<CustomInput> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        maxLength: widget.obscureText ? 8 : widget.maxLength,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        style: TextStyle(
          color: ConstantString.darkBlue,
          fontFamily: ConstantString.fontFredoka,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: ConstantString.lightBlue,
            fontFamily: ConstantString.fontFredoka,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            widget.prefixIcon, 
            color: ConstantString.lightBlue
          ),
          suffixIcon: widget.obscureText 
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ConstantString.lightBlue,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
          filled: true,
          fillColor: ConstantString.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ConstantString.darkBlue, 
              width: 2
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ConstantString.red, 
              width: 2
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ConstantString.red, 
              width: 2
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, 
            vertical: 12
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}