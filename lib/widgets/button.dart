import 'package:flutter/material.dart';
import 'package:note_taking_app/constants/colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.icon,
    this.color,
    this.radius,
    this.width,
    this.height,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final Color? color;
  final double? radius;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.28,
      height: height ?? 40,
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color ?? const Color(CustomColors.eggplant),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(text),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
