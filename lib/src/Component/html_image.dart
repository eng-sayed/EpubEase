import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class HtmlImage extends StatelessWidget {
  final Uint8List bytes;

  const HtmlImage({
    required this.bytes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(bytes);
  }
}
