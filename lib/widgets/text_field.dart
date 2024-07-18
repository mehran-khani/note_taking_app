import 'package:flutter/material.dart';
import 'package:note_taking_app/constants/colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    required this.textEditingController,
    required this.error,
    required this.invisible,
    this.errorText,
    this.keyboardType,
    this.suffixIcon,
    this.onIconTapped,
  });
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final bool error;
  final String? errorText;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final VoidCallback? onIconTapped;
  final bool invisible;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.83,
          padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
          child: TextField(
            keyboardType: keyboardType,
            obscureText: invisible,
            obscuringCharacter: '*',
            autocorrect: false,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: onIconTapped,
                child: Icon(suffixIcon),
              ),
              errorText: error ? errorText : null,
              errorStyle: const TextStyle(color: Color(CustomColors.lightGray)),
              hintText: hintText,
              // hintStyle: TextStyle(color: error ? Colors.white : Colors.grey),
              labelText: labelText,
              labelStyle: TextStyle(color: error ? Colors.white : Colors.grey),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(CustomColors.lightGray),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              filled: true,
              fillColor: const Color(CustomColors.navy),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(CustomColors.lightGray)),
                borderRadius: BorderRadius.circular(28.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(CustomColors.lightGray)),
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            controller: textEditingController,
          ),
        ),
      ],
    );
  }
}
