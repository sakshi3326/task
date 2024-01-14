import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/common_method.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/signup/register.dart';

import '../login/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  initState() {
    super.initState();
    CommonMethods.hideKeyboard();
    Future.delayed(
      const Duration(seconds: 03),
      () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    LocalImages.icTasks,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Buddy",
                  style: CommonStyle.getRalewayFont(
                    color: CommonColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
