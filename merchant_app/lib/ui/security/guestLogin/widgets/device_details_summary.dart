import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';

class DeviceDetailsSummary extends StatelessWidget {
  final DeviceDetails? deviceDetails;
  final bool hasDeviceDetailsLoaded;

  const DeviceDetailsSummary({
    required this.deviceDetails,
    required this.hasDeviceDetailsLoaded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        context.headingXSmall('Merchant Information', isBold: true),
        const SizedBox(height: 24),
        _deviceInfo(context),
      ],
    );
  }

  Widget _deviceInfo(BuildContext context) => hasDeviceDetailsLoaded
      ? Column(
          children: [
            _deviceRow(context, 'Device ID:', deviceDetails?.deviceId ?? ''),
            _deviceRow(
              context,
              'Merchant ID:',
              deviceDetails?.merchantId ?? '',
            ),
          ],
        )
      : context.paragraphMedium('No Device Information Available');

  Widget _deviceRow(BuildContext context, String title, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      context.paragraphSmall(title),
      const SizedBox(width: 8),
      context.paragraphSmall(value),
    ],
  );
}
