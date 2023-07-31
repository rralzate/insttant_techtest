import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/fonts.dart';

class CustomInput extends StatelessWidget {
  final String placeholder;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool showCounter;
  final FocusNode focusNode;

  const CustomInput({
    Key? key,
    required this.placeholder,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.errorText,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    this.showCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          focusNode: focusNode,
          maxLines: maxLines ?? 1,
          controller: controller,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLength: maxLength,
          style: textGrayStyleInput,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorText: errorText,
            errorMaxLines: 2,
            hintText: placeholder,
            counterText: '',
            hintStyle: textGrayStylePlaceholder,
          ),
        ),
        if (showCounter)
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller?.text.length}${maxLength != null ? ' / $maxLength' : ''}',
                style: textBlackStyle,
              ),
            ),
          )
      ],
    );
  }
}
