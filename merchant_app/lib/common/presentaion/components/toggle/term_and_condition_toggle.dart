import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';
import 'package:littlefish_merchant/common/presentaion/pages/pdf_viewer/local_pdf_viewer_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/web_view_screen.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';

class TermAndConditionToggle extends StatefulWidget {
  final bool isAccepted;
  final String url;
  final Function(bool) onChanged;

  const TermAndConditionToggle({
    super.key,
    required this.url,
    required this.isAccepted,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _TermAndConditionToggleState();
}

class _TermAndConditionToggleState extends State<TermAndConditionToggle> {
  bool _isTermsAndConditionsAccepted = false;

  @override
  void initState() {
    super.initState();
    _isTermsAndConditionsAccepted = widget.isAccepted;
  }

  @override
  Widget build(BuildContext context) {
    return _toggleViewer(context);
  }

  bool _isUrlPdf(String url) {
    return url.endsWith('.pdf') || url.endsWith('.PDF');
  }

  // TODO(lampian): consider adding this to a helper if used elsewhere
  bool _isAsset(String url) {
    return url.contains('asset');
  }

  Widget _toggleViewer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ToggleSwitch(
            enabledColor: Theme.of(context).colorScheme.secondary,
            initiallyEnabled: widget.isAccepted ?? false,
            onChanged: (isAccepted) {
              if (mounted) {
                setState(() {
                  widget.onChanged(isAccepted);
                  _isTermsAndConditionsAccepted = isAccepted;
                });
              }
            },
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: context.paragraphMedium('I have read and accept the \n'),
              ),
              SizedBox(
                height: 20,
                child: InkWell(
                  child: context.paragraphMedium(
                    'Terms and Conditions',
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.brand,
                    isUnderLined: true,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      CustomRoute(
                        builder: (ctx) => _isUrlPdf(widget.url)
                            ? LocalPdfViewerPage(
                                title: 'Terms and Conditions',
                                pdfSource: _isAsset(widget.url)
                                    ? PdfSource.isAsset
                                    : PdfSource.isNetwork,
                                path: widget.url,
                              )
                            : WebViewScreen(
                                title: 'Terms & Conditions',
                                url: widget.url,
                                isAsset: _isAsset(widget.url),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
