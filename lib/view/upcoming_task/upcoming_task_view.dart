import 'package:calender_picker/calender_picker.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/upcoming_task/widget/upcoming_schedule_list.dart';
import 'package:task/widget/app_bar/app_bar.dart';

class UpcomingTaskView extends StatefulWidget {
  const UpcomingTaskView({Key? key}) : super(key: key);

  @override
  State<UpcomingTaskView> createState() => _UpcomingTaskViewState();
}

class _UpcomingTaskViewState extends State<UpcomingTaskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Projects",
        firstIcon: Icons.category_outlined,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade200,
                      Colors.blue.shade300,
                      Colors.blue,
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Projects summary",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text('Features'),
                      Text('1. Create Projects'),
                      Text('2. See the Projects assigned to you'),
                      Text('3. Delete a Project by swiping left to right'),

                    ],
                  ),
                ),
              ),
              UpcomingScheduleListView(
                onTap: (int index) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
