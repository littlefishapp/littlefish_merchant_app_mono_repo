// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Package imports:
import 'package:fast_contacts/fast_contacts.dart' as contact_service;

// Project imports:
import 'package:littlefish_merchant/models/shared/data/contact.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/contacts/contacts_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ContactsList extends StatefulWidget {
  final List<Contact> contacts;

  const ContactsList({Key? key, required this.contacts}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text(
                    'Import Contacts',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                EnvironmentProvider.instance.isLargeDisplay!
                    ? showPopupDialog<List<contact_service.Contact>>(
                        context: context,
                        content: const ContactsSelectPage(),
                      )
                    : showDialog<List<contact_service.Contact>>(
                        context: context,
                        builder: (ctx) => const ContactsSelectPage(),
                      ).then((result) {
                        // Selected contacts
                        if (result != null) {
                          // Loop through all selected contacts we wish
                          // to import.
                          for (var ic in result) {
                            Contact selectedContact = Contact.fromContact(ic);
                            // Loop through all previously imported contacts
                            // to check if the selected contact is already imported
                            // based on one of their contact details.
                            var existingIndex = widget.contacts.indexWhere(
                              (prevImportedContact) =>
                                  prevImportedContact
                                      .contactDetails![0]
                                      .value ==
                                  selectedContact.contactDetails![0].value,
                            );

                            if (existingIndex >= 0) {
                              // Show a dialog saying the contact is already imported
                              // Replace with your showMessageDialog method
                              showMessageDialog(
                                context,
                                '${ic.displayName} already imported.',
                                LittleFishIcons.info,
                              );
                            } else {
                              // Add the contact to widget.contacts
                              widget.contacts.add(Contact.fromContact(ic));
                            }
                          }
                          if (mounted) setState(() {});
                        }
                      });

                // if (EnvironmentProvider.instance.isLargeDisplay!)
                //   showPopupDialog<List<contactService.Contact>>(
                //           context: context, content: ContactsSelectPage())
                //       .then((result) {
                //     if (result != null) {
                //       result.forEach(
                //         (ic) =>
                //             widget.contacts.add(Contact.fromContact(ic)),
                //       );

                //       if (mounted) setState(() {});
                //     }
                //   });
                // else
                //   showDialog<List<contactService.Contact>>(
                //           context: context,
                //           builder: (ctx) => ContactsSelectPage())
                //       .then((result) {
                //     if (result != null) {
                //       result.forEach(
                //         (ic) =>
                //             widget.contacts.add(Contact.fromContact(ic)),
                //       );

                //       if (mounted) setState(() {});
                //     }
                //   });
              },
            ),
          ],
        ),
        const CommonDivider(),
        Expanded(
          child: widget.contacts.isEmpty
              ? Center(
                  child: Text(
                    'No contacts imported.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = widget.contacts[index];
                    return ContactTile(
                      item: item,
                      dismissAllowed: true,
                      onRemove: (item) {
                        widget.contacts.remove(item);
                        setState(() {});
                      },
                    );
                  },
                  itemCount: widget.contacts.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const CommonDivider(),
                ),
        ),
        const CommonDivider(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Done',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop(widget.contacts);
          },
        ),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  final Contact item;
  final bool dismissAllowed;
  final Function(Contact? item)? onRemove;

  final Function(Contact? item)? onTap;

  final bool selected;

  const ContactTile({
    Key? key,
    required this.item,
    this.onTap,
    this.onRemove,
    this.dismissAllowed = false,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleContactTile(context)
        : contactTile(context);
  }

  Slidable dismissibleContactTile(BuildContext context) => Slidable(
    key: Key(item.id!),
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, null);

            if (result == true) {
              onRemove!(item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: contactTile(context),
  );

  ExpansionTile contactTile(BuildContext context) => ExpansionTile(
    leading: OutlineGradientAvatar(
      child: DecoratedText(
        item.name!.substring(0, 2),
        alignment: Alignment.center,
        fontSize: null,
      ),
    ),
    title: Text(item.name!), //Text(widget.contacts[index].name!),
    children: item.contactDetails!
        .map(
          (cd) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ExpansionTile(
              leading: cd.isEmail ?? false
                  ? const Icon(Icons.email)
                  : const Icon(Icons.phone),
              title: Text('${cd.label} - ${cd.value}'),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: <Widget>[
                      YesNoFormField(
                        labelText: 'Primary',
                        initialValue: cd.isPrimary,
                        onSaved: (value) {
                          cd.isPrimary = value;
                        },
                      ),
                      cd.isEmail ?? false
                          ? StringFormField(
                              hintText: 'Enter email',
                              key: Key('${cd.label}:${item.id}'),
                              labelText: 'Email Address',
                              onSaveValue: (value) {
                                cd.value = value;
                              },
                              inputAction: TextInputAction.done,
                              initialValue: cd.value,
                            )
                          : MobileNumberFormField(
                              enabled: false,
                              hintText: '+XX XXX XXXX XXX',
                              key: Key('${cd.label}:${item.id}'),
                              labelText: 'Mobile Number',
                              onSaveValue: (value) {
                                cd.value = value;
                              },
                              inputAction: TextInputAction.done,
                              initialValue: cd.value,
                              country: LocaleProvider.instance.currentLocale,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}
