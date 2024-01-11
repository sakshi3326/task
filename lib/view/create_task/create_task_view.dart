import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/common_method.dart';
import 'package:task/view/create_task/widget/category_list.dart';
import 'package:task/view/create_task/widget/date_picker_widget.dart';
import 'package:task/view/create_task/widget/description.dart';
import 'package:task/view/create_task/widget/time_picker.dart';
import 'package:task/widget/app_bar/app_bar.dart';
import 'package:task/widget/custom_button/custom_buttons.dart';
import 'package:task/widget/textform_field/textform_field_view.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({Key? key}) : super(key: key);

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController groupName = TextEditingController();
  TextEditingController taskName = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonMethods.hideKeyboard();
      },
      child: Scaffold(
        backgroundColor: CommonColors.whiteColor,
        appBar: AppBarView(
          title: "Create Project and Task",
          firstIcon: Icons.arrow_back_ios_new_rounded,
          onBackPress: () {
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(top: 50, left: 26, right: 26, bottom: 10),
            child: Column(
              children: [
                TextFormFieldCustom(
                  titleName: "Project Name",
                  isTitleName: true,
                  controller: groupName,
                  hintText: "Enter your Project Name",
                  textInputType: TextInputType.text,
                ),
                TextFormFieldCustom(
                  titleName: "Task Name",
                  isTitleName: true,
                  controller: taskName,
                  hintText: "Task Name",
                  textInputType: TextInputType.text,
                ),
                // const DatePickerView(),
                // const TimePickerView(),
                TextFormFieldCustom(
                  titleName: "Start Date",
                  isTitleName: true,
                  controller: startDate,
                  hintText: "Enter your Project starting date",
                  textInputType: TextInputType.text,
                ),
                TextFormFieldCustom(
                  titleName: "End Date",
                  isTitleName: true,
                  controller: endDate,
                  hintText: "Enter the deadline date",
                  textInputType: TextInputType.text,
                ),
                // const DescriptionView(),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 30),
                  child: SizedBox(
                    height: 46,
                    child: PrimaryButton(
                      buttonText: "Create",
                      callBack: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
