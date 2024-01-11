import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/view/inbox/widget/inbox_list.dart';
import 'package:task/widget/app_bar/app_bar.dart';

class InboxView extends StatefulWidget {
  const InboxView({Key? key}) : super(key: key);

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Inbox",
        firstIcon: Icons.category_outlined,
        onBackPress: () {},
        secondIcon: Icons.settings_input_composite_outlined,
        onNextPress: () {},
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
          child: Column(
            children: [
              InboxListView(
                titleText: "Today",
                onTap: (int index) {},
              ),
              const SizedBox(height: 20),
              InboxListView(
                titleText: "Yesterday",
                onTap: (int index) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
