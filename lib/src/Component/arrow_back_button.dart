import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const arrowSvg =
    """<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M9 5L2.5 11.5L9 18" stroke="#FEF9F2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M22 11.5L3.58334 11.5" stroke="#FEF9F2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""";

class ArrowBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ArrowBackButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 24,
      icon: SvgPicture.string(
        arrowSvg,
        height: 24,
        width: 24,
      ),
    );
  }
}
