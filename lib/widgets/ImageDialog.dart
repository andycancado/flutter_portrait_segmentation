import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final Uint8List l;
  ImageDialog(this.l);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            width: 224,
            height: 224,
            decoration:
                BoxDecoration(image: DecorationImage(image: MemoryImage(l)))));
  }
}
