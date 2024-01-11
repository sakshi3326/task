import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';

class StatisticsListView extends StatefulWidget {
  final Function? onTap;
  const StatisticsListView({this.onTap, Key? key})
      : super(key: key);

  @override
  State<StatisticsListView> createState() => _StatisticsListViewState();
}

class _StatisticsListViewState extends State<StatisticsListView> {
  List onBorderingData = [
    {
      "image": LocalImages.icMeeting,
      "taskText": "Project Meeting",
      "taskTime": "09:00 AM To 11:00 AM",
    },
    {
      "image": LocalImages.icWebDesign,
      "taskText": "Web page design",
      "taskTime": "12:30 PM To 02:00 PM",
    },
    {
      "image": LocalImages.icAppDev,
      "taskText": "App Development",
      "taskTime": "12:30 PM To 02:00 PM",
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
              "Latest Activity",
              style: CommonStyle.getRalewayFont(
                color: CommonColors.blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    color: CommonColors.bottomIconColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
