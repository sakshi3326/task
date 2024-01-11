import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/task_details/widget/task_members_list.dart';
import 'package:task/widget/app_bar/app_bar.dart';

class TaskDetailsView extends StatefulWidget {
  const TaskDetailsView({Key? key}) : super(key: key);

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Task Details",
        firstIcon: Icons.arrow_back_ios_new_rounded,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 26, right: 26, bottom: 20),
              child: Text(
                "UI Design",
                style: CommonStyle.getRalewayFont(
                  color: CommonColors.blackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 26, bottom: 20),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CommonColors.bottomIconColor.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: CommonColors.bottomIconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "09:00 AM To 11:00 AM",
                    style: CommonStyle.getRalewayFont(
                      color: CommonColors.textGeryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 26, right: 26, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        "Progress",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "70 %",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 14, right: 14, bottom: 20),
                  child: LinearPercentIndicator(
                    width: 364,
                    lineHeight: 08,
                    percent: 0.7,
                    backgroundColor:
                        CommonColors.bottomIconColor.withOpacity(0.2),
                    progressColor: CommonColors.bottomIconColor,
                    barRadius: const Radius.circular(15),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 26, right: 26, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OverView",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "The project will incorporate several popular web development technologies. Much of the time, the tools and programming languages taught in a classroom setting are learned and practiced in isolation from one another",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.textGeryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      // ReadMore(
                      //   'The project will incorporate several popular web development technologies. Much of the time, the tools and programming languages taught in a classroom setting are learned and practiced in isolation from one another',
                      //   style: CommonStyle.getRalewayFont(
                      //       color: CommonColors.textGeryColor,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 14),
                      //   trimLines: 4,
                      //   colorClickableText: Colors.blue,
                      //   trimMode: TrimMode.Line,
                      //   trimCollapsedText: 'Read more',
                      //   trimExpandedText: 'Show less',
                      //   lessStyle: CommonStyle.getRalewayFont(
                      //       color: CommonColors.bottomIconColor,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 14),
                      //   moreStyle: CommonStyle.getRalewayFont(
                      //       color: CommonColors.bottomIconColor,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 14),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 26, right: 26, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Members",
                        style: CommonStyle.getRalewayFont(
                          color: CommonColors.blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      overlapped(),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26, right: 26, bottom: 30),
              child: TaskMembersList(
                onTap: (int index) {
                  if (index == 0) {}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget overlapped() {
    const overlap = 30;
    final items = [
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: CommonColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const Image(
              image: NetworkImage(
                  'https://uploads-ssl.webflow.com/60c11f0c32e847294cfbcb6c/60c1401d63769509bd4e72cd_Rectangle%202.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: CommonColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const Image(
              image: NetworkImage(
                  'https://w0.peakpx.com/wallpaper/763/605/HD-wallpaper-chris-pine-american-actor-portrait-handsome-man-american-stars.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: CommonColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const Image(
              image: NetworkImage(
                  'https://media.istockphoto.com/id/644244886/photo/portrait-of-businessman-in-office-standing-by-window.jpg?b=1&s=170667a&w=0&k=20&c=g9g077LMBXXEynx8xcKeEjH6r6Q4svu5OzT5zOSzGoM='),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: CommonColors.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: const Image(
              image: NetworkImage(
                  'https://media.istockphoto.com/id/503918553/photo/happiness-is-not-trying-or-finding-its-deciding.jpg?s=612x612&w=0&k=20&c=WFc4kZTwbtneCvuRdlB9fVkZUVV7siS5mKud4XKBuE4='),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: CommonColors.containerIconB,
        ),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(color: CommonColors.whiteColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            onTap: () {},
            child: const Icon(
              Icons.add,
              color: CommonColors.bottomIconColor,
            ),
          ),
        ),
      ),
    ];
    List<Widget> stackLayers = List<Widget>.generate(
      items.length,
      (index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
          child: items[index],
        );
      },
    );
    return Stack(children: stackLayers);
  }
}
