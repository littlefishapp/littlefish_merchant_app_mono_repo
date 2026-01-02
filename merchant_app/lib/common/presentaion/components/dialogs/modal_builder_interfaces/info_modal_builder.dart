import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/enums.dart';

abstract class InfoModalBuilder {
  Widget buildInfoModal({
    required BuildContext context,
    required String title,
    required String description,
    required StatusType status,
  });
}
