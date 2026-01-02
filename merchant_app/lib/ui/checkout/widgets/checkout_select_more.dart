import 'package:flutter/material.dart';

class CheckoutSelectMore extends StatelessWidget {
  final void Function() onTap;
  const CheckoutSelectMore({
    Key? key,
    required GlobalKey<State<StatefulWidget>> moreKey,
    required this.onTap,
  }) : _moreKey = moreKey,
       super(key: key);

  final GlobalKey<State<StatefulWidget>> _moreKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: IconButton(
        key: _moreKey,
        icon: const Icon(Icons.add),
        onPressed: onTap,
      ),
    );
  }
}
