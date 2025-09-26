import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.textButton,
    required this.onPress,
    this.height,
    this.colorButton,
    this.width,
    this.textStyle,
  });

  final String textButton;
  final VoidCallback onPress;
  final double? height;
  final double? width;
  final Color? colorButton;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: colorButton ?? Colors.white,
        ),
        child: Center(
          child: Text(
            textButton,
            style:
                textStyle ??
                const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
