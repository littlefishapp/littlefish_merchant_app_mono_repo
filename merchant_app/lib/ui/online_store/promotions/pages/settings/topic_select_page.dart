// removed ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';

class TopicSelectPage extends StatefulWidget {
  final dynamic item;

  const TopicSelectPage({Key? key, required this.item}) : super(key: key);

  @override
  State<TopicSelectPage> createState() => _TopicSelectPageState();
}

class _TopicSelectPageState extends State<TopicSelectPage> {
  String? selectedTopic;
  final AsyncMemoizer<dynamic> _memoizer = AsyncMemoizer();
  dynamic item;
  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        item.audience ??= Audience();

        return AppSimpleAppScaffold(
          title: 'Choose Your Audience',
          body: SafeArea(
            child: vm.isLoading!
                ? const AppProgressIndicator()
                : FutureBuilder(
                    future: _memoizer.runOnce(() => vm.getCustomerLists()),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const AppProgressIndicator();
                      }

                      var customerLists = snapshot.data as List<CustomerList>;

                      return Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: 8),
                              ListTile(
                                tileColor: Theme.of(
                                  context,
                                ).colorScheme.background,
                                selected: selectedTopic == 'Store Followers',
                                title: const Text('Store Followers'),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  item.audience.audienceType =
                                      AudienceType.topic;
                                  item.audience.topicEasyName =
                                      'Store Followers';
                                  item.audience.topic = vm.item!.businessId;

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const CommonDivider(),
                              ListTile(
                                tileColor: Theme.of(
                                  context,
                                ).colorScheme.background,
                                selected: selectedTopic == 'Local Community',
                                title: const Text('Local Community'),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  item.audience.audienceType =
                                      AudienceType.topic;
                                  item.audience.topicEasyName =
                                      'Local Community';
                                  item.audience.topic =
                                      vm.item!.primaryAddress!.city;

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const CommonDivider(),
                              ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) => ListTile(
                                  tileColor: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  selected:
                                      selectedTopic ==
                                      customerLists[index].displayName,
                                  title: Text(
                                    customerLists[index].displayName!,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    item.audience.audienceType =
                                        AudienceType.list;
                                    item.audience.customerListName =
                                        customerLists[index].displayName;
                                    item.audience.customerListId =
                                        customerLists[index].id;

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                separatorBuilder: (ctx, index) =>
                                    const CommonDivider(),
                                itemCount: customerLists.length,
                              ),
                              const CommonDivider(),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
