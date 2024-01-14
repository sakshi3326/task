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


      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: UpcomingScheduleListView(
                  onTap: (int index) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
