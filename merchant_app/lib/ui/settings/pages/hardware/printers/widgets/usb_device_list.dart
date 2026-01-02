// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/tools/managers/device_manager.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';

// import 'package:usb_serial/usb_serial.dart';

class USBDeviceList extends StatefulWidget {
  final Function(dynamic) onDeviceSelected;

  const USBDeviceList({Key? key, required this.onDeviceSelected})
    : super(key: key);

  @override
  State<USBDeviceList> createState() => _USBDeviceListState();
}

class _USBDeviceListState extends State<USBDeviceList> {
  // final bool _isLoading = false;

  late DeviceManager deviceManager;

  @override
  void initState() {
    deviceManager = DeviceManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DropdownFormField(
          hintText: 'select an device',
          key: const Key('usb_device'),
          labelText: 'Select Device',
          isRequired: true,
          onSaveValue: (value) => widget.onDeviceSelected(value.value),
          onFieldSubmitted: (value) => widget.onDeviceSelected(value.value),
          values: deviceManager.hasDevices
              ? deviceManager.usbDevices
                    .asMap()
                    .entries
                    .map(
                      (device) => DropDownValue(
                        displayValue: device.value.toString(),
                        index: device.key,
                        value: device.value,
                      ),
                    )
                    .toList()
              : [
                  DropDownValue(
                    displayValue: 'No Devices Found',
                    index: 0,
                    value: null,
                  ),
                ],
        ),
        // SizedBox(
        //   child: CapsuleButton(
        //     text: "Search",
        //     onTap: (c) => searchDevices(),
        //   ),
        // )
      ],
    );
  }

  Future<void> searchDevices() async {
    await deviceManager.getUSBDeviceList();

    if (mounted) setState(() {});
  }
}
