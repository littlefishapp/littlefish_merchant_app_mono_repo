import 'dart:io';

import 'package:flutter/material.dart';

class ArrowForward extends StatelessWidget {
  const ArrowForward({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward);
  }
}
