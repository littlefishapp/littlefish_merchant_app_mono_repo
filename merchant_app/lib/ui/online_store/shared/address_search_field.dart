// // remove ignore_for_file: use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:littlefish_merchant/app/app.dart';
// import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
// import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
// import 'package:littlefish_merchant/common/presentaion/components/ensure_visible_focused.dart';
// import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
// import 'package:littlefish_merchant/ui/online_store/common/config.dart';

// class AddressSearchField extends StatefulWidget {
//   final String? hintText, labelText, initialValue;
//   final Function(String? value)? onSaveValue;
//   final Function(String value)? onFieldSubmitted, onChanged;
//   final FocusNode? focusNode;
//   final TextInputAction inputAction;
//   final IconData? suffixIcon, prefixIcon;
//   final double? iconSize;
//   final bool isRequired, obsecureText, autoValidate, useOutlineStyling, enabled;
//   final bool enforceMaxLength;
//   final int? maxLength;
//   final int minLength, minLines, maxLines;
//   final TextAlign textAlign;
//   final TextStyle? hintStyle, textStyle, labelStyle;
//   final TextEditingController? controller;
//   final Function(String? value)? asyncValidator;
//   final Function(StoreAddress? address) onSelected;

//   const AddressSearchField({
//     required Key key,
//     required this.onSelected,
//     required this.hintText,
//     required this.labelText,
//     this.onSaveValue,
//     this.inputAction = TextInputAction.done,
//     this.textAlign = TextAlign.left,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.iconSize,
//     this.onFieldSubmitted,
//     this.onChanged,
//     this.focusNode,
//     this.autoValidate = false,
//     this.initialValue,
//     this.isRequired = true,
//     this.obsecureText = false,
//     this.maxLength,
//     this.minLength = 0,
//     this.enforceMaxLength = false,
//     this.controller,
//     this.minLines = 1,
//     this.enabled = true,
//     this.useOutlineStyling = false,
//     this.asyncValidator,
//     this.maxLines = 1,
//     this.hintStyle,
//     this.textStyle,
//     this.labelStyle,
//   }) : super(key: key);

//   @override
//   State<AddressSearchField> createState() => _AddressSearchFieldState();
// }

// class _AddressSearchFieldState extends State<AddressSearchField> {
//   bool _isLoading = false;
//   late TextEditingController controller;
//   late String initialValue;

//   FocusNode? _focusNode;

//   @override
//   void initState() {
//     controller = widget.controller ?? TextEditingController();
//     initialValue = widget.initialValue ?? '';
//     controller.text = initialValue;
//     _focusNode = widget.focusNode ?? FocusNode();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(AddressSearchField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.controller != null &&
//         (widget.controller != oldWidget.controller)) {
//       controller = widget.controller ?? TextEditingController();
//     }

//     if (widget.initialValue != oldWidget.initialValue) {
//       controller = TextEditingController(text: widget.initialValue ?? '');
//     }

//     if (oldWidget.controller == null) {
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return EnsureVisibleWhenFocused(
//       focusNode: _focusNode,
//       child: TextFormField(
//         onTap: widget.enabled ? _searchAndChooseLocation : null,
//         minLines: widget.minLines,
//         maxLines: widget.maxLines,
//         key: widget.key,
//         enabled: _isLoading ? false : widget.enabled,
//         style: widget.textStyle,
//         controller: controller,
//         focusNode: _focusNode,
//         maxLength: widget.maxLength,
//         textAlign: widget.textAlign,
//         textCapitalization: widget.obsecureText
//             ? TextCapitalization.none
//             : TextCapitalization.sentences,
//         obscureText: widget.obsecureText,
//         decoration: InputDecoration(
//           isDense: true,
//           counter: const SizedBox(
//             height: 0.0,
//           ),
//           suffixIconColor: Theme.of(context).colorScheme.secondary,
//           prefixIconColor: Theme.of(context).colorScheme.secondary,
//           suffixIcon: _isLoading
//               ? const AppProgressIndicator()
//               : (widget.suffixIcon != null
//                   ? Icon(widget.suffixIcon, size: widget.iconSize)
//                   : null),
//           prefixIcon: _isLoading
//               ? const AppProgressIndicator()
//               : (widget.prefixIcon != null
//                   ? Icon(widget.prefixIcon, size: widget.iconSize)
//                   : null),
//           labelText:
//               widget.isRequired ? '${widget.labelText} *' : widget.labelText,
//           labelStyle: widget.labelStyle,
//           alignLabelWithHint: true,
//           hintText: widget.hintText,
//           hintStyle: widget.hintStyle,
//           fillColor: Colors.white,
//           filled: true,
//           border: InputBorder.none,
//           enabledBorder: widget.useOutlineStyling
//               ? OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),
//                   borderSide: BorderSide(
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                 )
//               : const UnderlineInputBorder(),
//           focusedBorder: widget.useOutlineStyling
//               ? OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),
//                   borderSide: BorderSide(
//                     color: Theme.of(context).colorScheme.onSecondary,
//                   ),
//                 )
//               : const UnderlineInputBorder(),
//           disabledBorder: widget.useOutlineStyling
//               ? OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),
//                   borderSide: BorderSide(
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                 )
//               : const UnderlineInputBorder(),
//         ),
//         enableInteractiveSelection: true,
//         keyboardType:
//             widget.maxLines <= 1 ? TextInputType.text : TextInputType.multiline,
//         textInputAction: widget.inputAction,
//         onFieldSubmitted: (value) {
//           if (null != widget.onFieldSubmitted) widget.onFieldSubmitted!(value);
//         },
//         onChanged: (value) {
//           if (null != widget.onChanged) widget.onChanged!(value);
//         },
//         readOnly: !widget.enabled,
//         validator: (value) {
//           if (!validateValue(value)) {
//             return 'Please enter a valid value for ${widget.labelText}';
//           }

//           if (widget.asyncValidator != null) return asyncValidation(value);

//           return null;
//         },
//         onSaved: (value) {
//           if (widget.onSaveValue == null) return;
//           if (validateValue(value)) {
//             widget.onSaveValue!(value);
//           }
//         },
//       ),
//     );
//   }

//   String? asyncValidation(String? value) {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       var result = widget.asyncValidator!(value);
//       return result;
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       _isLoading = false;
//     }

//     return null;
//   }

//   bool validateValue(String? value) {
//     if (value == null || value.isEmpty) {
//       if (!widget.isRequired) return true;
//       return false;
//     }

//     if (widget.minLength > 0) {
//       return value.length >= widget.minLength;
//     }

//     return true;
//   }

//   Future<void> _searchAndChooseLocation() async {
//     try {
//       Prediction? prediction = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: kGoogleApiKey,
//         onError: (error) {
//           reportCheckedError(Exception(error.errorMessage));

//           showMessageDialog(
//             context,
//             'Error',
//             Icons.location_off,
//           );
//         },
//         mode: Mode.overlay,
//         language: kDefaultLanguageCode,
//         components: [],
//       );

//       if (prediction == null || prediction.description == null) return;

//       var result = await locationFromAddress(prediction.description!);

//       if (result.isEmpty) {
//         showMessageDialog(
//           context,
//           'Address not Found',
//           Icons.location_off,
//         );

//         return;
//       }
//       var placeMark = await placemarkFromCoordinates(
//         result.first.latitude,
//         result.first.longitude,
//       );

//       var address = StoreAddress(
//         location: StoreLocation(
//           latitude: result.first.latitude,
//           longitude: result.first.longitude,
//         ),
//         locationId: prediction.placeId,
//         friendlyName: prediction.description,
//         addressLine1: placeMark.first.street,
//         city: placeMark.first.locality,
//         country: placeMark.first.country,
//         id: prediction.id,
//         placeId: prediction.placeId,
//         postalCode: placeMark.first.postalCode,
//         state: placeMark.first.administrativeArea,
//       );

//       widget.onSelected(address);

//       if (mounted) setState(() {});
//     } catch (error) {
//       reportCheckedError(error);

//       await showMessageDialog(
//         context,
//         'Error',
//         LittleFishIcons.error,
//       );
//     }
//   }
// }
