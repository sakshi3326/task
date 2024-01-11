import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/schedule/widget/schedule_list.dart';
import 'package:task/widget/app_bar/app_bar.dart';
import 'package:task/widget/custom_button/custom_buttons.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Schedule",
        firstIcon: Icons.arrow_back_ios_new_rounded,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildDefaultSingleDatePickerWithValue(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: ScheduleListView(),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: SizedBox(
                height: 46,
                child: PrimaryButton(
                  buttonText: "Schedule",
                  callBack: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
        selectedDayHighlightColor: CommonColors.bottomIconColor,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: CommonStyle.getRalewayFont(
            color: CommonColors.bottomIconColor, fontWeight: FontWeight.w700),
        firstDayOfWeek: 1,
        controlsHeight: 40,
        controlsTextStyle: CommonStyle.getRalewayFont(
            fontSize: 16,
            color: CommonColors.bottomIconColor,
            fontWeight: FontWeight.w700),
        dayTextStyle: const TextStyle(color: CommonColors.textGeryColor),
        disabledDayTextStyle:
            const TextStyle(color: CommonColors.textGeryColor),
        selectableDayPredicate: (day) => !day
            .difference(DateTime.now().subtract(const Duration(days: 3)))
            .isNegative);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: config,
          value: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (dates) =>
              setState(() => _singleDatePickerValueWithDefaultValue = dates),
        ),
      ],
    );
  }
}
