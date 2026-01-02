import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_secondary.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';

class TransactionFilterSortActionButton extends StatelessWidget {
  final Function(BuildContext) _onPressed;

  const TransactionFilterSortActionButton({
    Key? key,
    required Function(BuildContext) onPressed,
  }) : _onPressed = onPressed,
       super(key: key);

  @override
  Widget build(BuildContext context) => Semantics(
    identifier: SemanticsConstants.kFilter,
    label: SemanticsConstants.kFilter,
    child: SquareIconButtonSecondary(
      onPressed: _onPressed,
      icon: Icons.tune_outlined,
    ),
  );
}
