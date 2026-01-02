import 'package:flutter/material.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class IdentificationCard extends StatelessWidget {
  final IconData icon;
  final String iconText;
  final String mainText;
  final Color? selectedBorderColour;
  final bool selected;
  final void Function()? onTap;

  const IdentificationCard({
    Key? key,
    required this.icon,
    required this.iconText,
    required this.mainText,
    this.onTap,
    this.selected = false,
    this.selectedBorderColour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color selectedBorderColour =
        this.selectedBorderColour ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap ?? () {},
      child: CardNeutral(
        // color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
        // TODO(lamppian): replace shadow with alternative
        // shadowColor: selected
        //               ? selectedBorderColour
        //               : Theme.of(context).colorScheme.primary,
        elevation: selected ? 3 : 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? selectedBorderColour : Colors.grey,
              width: selected ? 2.0 : 1,
            ),
            borderRadius: BorderRadius.circular(
              8.0,
            ), // Adjust the radius as needed
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48),
                    const SizedBox(height: 8.0),
                    Text(
                      iconText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  mainText,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum IdentificationMethod { accountNumber, merchantID, deviceSerialNo }

class CustomOptionTile extends StatelessWidget {
  final String title;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomOptionTile({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black,
                  width: 2.0,
                ),
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16.0)
                  : null,
            ),
            Expanded(
              child: description == null || description!.isEmpty
                  ? Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(description!, softWrap: true),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
