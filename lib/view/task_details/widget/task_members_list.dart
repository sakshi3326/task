import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';

class TaskMembersList extends StatefulWidget {
  final Function? onTap;
  const TaskMembersList({this.onTap, Key? key}) : super(key: key);

  @override
  State<TaskMembersList> createState() => _TaskMembersListState();
}

class _TaskMembersListState extends State<TaskMembersList> {
  List onBorderingData = [
    {
      "image": LocalImages.icIntroduction,
      "taskText": "Introduction",
      "taskTime": "David Johnson",
    },
    {
      "image": LocalImages.icProDescription,
      "taskText": "Project Description",
      "taskTime": "Henry Miller",
    },
    {
      "image": LocalImages.icUIDesign,
      "taskText": "Project Designer",
      "taskTime": "Thomas Taylor",
    },
    {
      "image": LocalImages.icWebDev,
      "taskText": "Web Developer",
      "taskTime": "Michael Harris",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Task",
              style: CommonStyle.getRalewayFont(
                color: CommonColors.blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.only(top: 10),
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
                          Container(
                            margin: const EdgeInsets.all(12),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: index == 0
                                    ? CommonColors.bottomIconColor
                                    : CommonColors.bottomIconColor
                                        .withOpacity(0.2)),
                            child: const Icon(
                              Icons.check,
                              color: CommonColors.whiteColor,
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
