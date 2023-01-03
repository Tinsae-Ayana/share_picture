import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color textColor;
  const FollowButton(
      {super.key,
      required this.backgroundColor,
      required this.borderColor,
      required this.label,
      required this.textColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 28),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5)),
          width: 250,
          height: 27,
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
