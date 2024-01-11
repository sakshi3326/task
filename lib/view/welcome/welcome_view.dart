import 'package:flutter/material.dart';
import 'package:task/core/app_strings.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/bottom_bar/bottom_nav_bar_for_task/bottom_nav_for_task.dart';
import 'package:task/widget/custom_button/custom_buttons.dart';

class WelComeView extends StatefulWidget {
  const WelComeView({Key? key}) : super(key: key);

  @override
  State<WelComeView> createState() => _WelComeViewState();
}

class _WelComeViewState extends State<WelComeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              CommonColors.bottomIconColor,
              CommonColors.whiteColor,
            ],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(LocalImages.icTask),
                ),
                const SizedBox(height: 60),
                Text(
                  AppStrings.welcome,
                  style: CommonStyle.getRalewayFont(
                    color: CommonColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.welcomeText,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: CommonStyle.getRalewayFont(
                    color: CommonColors.textGeryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: 46,
                    child: PrimaryButton(
                      buttonText: AppStrings.lestStart,
                      callBack: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavigationForTaskView(
                              selectedIndex: 0,
                              message: '',
                            ),
                          ),
                        );
                      },
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
