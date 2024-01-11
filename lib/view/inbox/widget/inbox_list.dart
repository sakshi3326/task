import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';

class InboxListView extends StatefulWidget {
  final String? titleText;
  final Function? onTap;

  const InboxListView({this.titleText, this.onTap, Key? key}) : super(key: key);

  @override
  State<InboxListView> createState() => _InboxListViewState();
}

class _InboxListViewState extends State<InboxListView> {
  List onBorderingData = [
    {
      "image":
          "https://uploads-ssl.webflow.com/60c11f0c32e847294cfbcb6c/60c1401d63769509bd4e72cd_Rectangle%202.png",
      "taskText": "David Johnson",
      "text": "Tell me about your project.",
      "time": "10 Minutes ago",
    },
    {
      "image":
          "https://w0.peakpx.com/wallpaper/763/605/HD-wallpaper-chris-pine-american-actor-portrait-handsome-man-american-stars.jpg",
      "taskText": "Henry Miller",
      "text": "Let's schedule meeting.",
      "time": "11:45 am",
    },
    {
      "image":
          "https://media.istockphoto.com/id/644244886/photo/portrait-of-businessman-in-office-standing-by-window.jpg?b=1&s=170667a&w=0&k=20&c=g9g077LMBXXEynx8xcKeEjH6r6Q4svu5OzT5zOSzGoM=",
      "taskText": "Thomas Taylor",
      "text": "les't project is complete",
      "time": "10:00 am",
    },
    {
      "image":
          "https://media.istockphoto.com/id/503918553/photo/happiness-is-not-trying-or-finding-its-deciding.jpg?s=612x612&w=0&k=20&c=WFc4kZTwbtneCvuRdlB9fVkZUVV7siS5mKud4XKBuE4=",
      "taskText": "Michael Harris",
      "text": "Well done good job.",
      "time": "08:35 am",
    },
    {
      "image":
          "https://c0.wallpaperflare.com/preview/655/45/114/african-american-model-male-black-man.jpg",
      "taskText": "Brown Thomas",
      "text": "New task is ready.",
      "time": "08:10 am",
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
              widget.titleText ?? "",
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
                            margin: const EdgeInsets.all(08),
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: CommonColors.whiteColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  image: NetworkImage(
                                    onBorderingData[index]['image'] ?? "",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  onBorderingData[index]['taskText'] ?? "",
                                  textAlign: TextAlign.start,
                                  style: CommonStyle.getRalewayFont(
                                    color: CommonColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  onBorderingData[index]['text'] ?? "",
                                  style: CommonStyle.getRalewayFont(
                                    color: CommonColors.textGeryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              onBorderingData[index]['time'] ?? "",
                              style: CommonStyle.getRalewayFont(
                                color: CommonColors.textGeryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
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
