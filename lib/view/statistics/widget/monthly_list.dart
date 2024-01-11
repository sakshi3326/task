import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';

class MonthlyList extends StatefulWidget {
  const MonthlyList({Key? key}) : super(key: key);

  @override
  State<MonthlyList> createState() => _MonthlyListState();
}

class _MonthlyListState extends State<MonthlyList> {
  List onBorderingData = [
    {
      "taskText": "January",
    },
    {
      "taskText": "February",
    },
    {
      "taskText": "March",
    },
    {
      "taskText": "April",
    },
    {
      "taskText": "May",
    },
    {
      "taskText": "June",
    },
    {
      "taskText": "July",
    },
    {
      "taskText": "August",
    },
    {
      "taskText": "September",
    },
    {
      "taskText": "October",
    },
    {
      "taskText": "November",
    },
    {
      "taskText": "December",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 46,
      width: double.infinity,
      child: ListView.builder(
        itemCount: onBorderingData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (buildContext, index) => InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.only(right: 06),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: index == 4
                  ? CommonColors.bottomIconColor
                  : CommonColors.bottomIconColor.withOpacity(0.2),
            ),
            child: Text(
              onBorderingData[index]['taskText'] ?? "",
              style: CommonStyle.getRalewayFont(
                  color: index == 4
                      ? CommonColors.whiteColor
                      : CommonColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
