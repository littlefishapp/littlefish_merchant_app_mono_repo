import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// This page is used to get a group of availible batches, display them in a list, and allow the user to select one.
class SelectBatchReportPage extends StatefulWidget {
  final String? initialBatch;
  final ValueChanged<String> onSave;

  const SelectBatchReportPage({
    Key? key,
    this.initialBatch,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SelectBatchReportPage> createState() => _SelectBatchReportPageState();
}

class _SelectBatchReportPageState extends State<SelectBatchReportPage> {
  String? selectedBatch;
  late Future<List<String>> _batchesFuture;

  @override
  void initState() {
    super.initState();
    selectedBatch = widget.initialBatch;
    _batchesFuture = _fetchBatchNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Batch Number')),
      body: FutureBuilder<List<String>>(
        future: _batchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading batches'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No batches found'));
          } else {
            final batches = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Batch Number',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: batches
                          .map(
                            (batch) => ListTile(
                              title: Text(
                                batch,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).extension<AppliedTextIcon>()?.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              selected: selectedBatch == batch,
                              selectedTileColor: Theme.of(context)
                                  .extension<AppliedTextIcon>()
                                  ?.primary
                                  .withOpacity(0.1),
                              onTap: () {
                                setState(() {
                                  selectedBatch = batch;
                                });
                                widget.onSave(batch);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchBatchNumbers() async {
    // TODO: Replace with actual implementation to fetch batch numbers
    await Future.delayed(const Duration(seconds: 1));
    return ['Batch001', 'Batch002', 'Batch003'];
  }
}
