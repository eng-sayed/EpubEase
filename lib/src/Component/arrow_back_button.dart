import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArrowBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ArrowBackButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 24,
      icon: SvgPicture.asset(
        "assets/icons/arrow_left.svg",
        height: 24,
        width: 24,
      ),
    );
  }
}
