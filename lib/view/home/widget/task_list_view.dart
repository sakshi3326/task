import 'package:flutter/material.dart';
import 'package:task/core/app_strings.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/widget/custom_button/custom_buttons.dart';

class TaskListView extends StatefulWidget {
  final String titleText;
  final Function? onTap;

  const TaskListView({required this.titleText, this.onTap, Key? key})
      : super(key: key);

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  List onBorderingData = [
    {
      "image": LocalImages.icUIDesign,
      "taskText": "UI Design",
      "taskTime": "09:00 AM To 11:00 AM",
    },
    {
      "image": LocalImages.icAppDev,
      "taskText": "App Development",
      "taskTime": "12:30 PM To 02:00 PM",
    },
    {
      "image": LocalImages.icWebDev,
      "taskText": "Web Development",
      "taskTime": "04:00 PM To 06:00 PM",
    },
    {
      "image": LocalImages.icDeshBoard,
      "taskText": "Dashboard Design",
      "taskTime": "09:00 PM To 10:00 PM",
    },
    {
      "image": LocalImages.icAccounting,
      "taskText": "Accounting",
      "taskTime": "11:00 PM To 11:45 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.titleText,
                style: CommonStyle.getRalewayFont(
                  color: CommonColors.blackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              AppTextButton(
                text: AppStrings.sellAll,
                textOnTap: () {},
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: onBorderingData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 06, bottom: 06),
                  child: InkWell(
                    onTap: () {
                      widget.onTap!(index);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: CommonColors.containerTextB.withOpacity(0.2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(14),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: CommonColors.containerIconB),
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                  onBorderingData[index]['image'] ?? "",
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  onBorderingData[index]['taskText'] ?? "",
                                  style: CommonStyle.getRalewayFont(
                                    color: CommonColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  onBorderingData[index]['taskTime'] ?? "",
                                  style: CommonStyle.getRalewayFont(
                                    color: CommonColors.textGeryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding:  EdgeInsets.all(14),
                            child:  Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: CommonColors.textGeryColor,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
