import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/service/auth_service.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/login/login_view.dart';
import 'package:task/view/profile/widget/setting_list_view.dart';
import 'package:task/view/profile/widget/switch_list_view.dart';
import 'package:task/view/schedule/schedule_view.dart';
import 'package:task/view/statistics/statistics_view.dart';
import 'package:task/view/upcoming_task/upcoming_task_view.dart';
import 'package:task/view/userInfo/userInfo.dart';
import 'package:task/widget/app_bar/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/helper_function.dart';
import '../../widget/widgets.dart';
import '../home/home_view.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? selectedImage;
  String userNameKey = "";
  AuthService authService = AuthService();
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    loadUserName();
    loadImage();
  }

  Future<void> loadUserName() async {
    String? storedUserName = await HelperFunctions.getUserNameFromSF();
    if (storedUserName != null) {
      setState(() {
        userNameKey = storedUserName;
      });
    }
  }

  Future<void> loadImage() async {
    prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        selectedImage = File(imagePath);
      });
    }
  }

  Future<void> saveImage(String imagePath) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('imagePath', imagePath);
  }

  Future<void> chooseImage(type) async {
    var image;

    if (type == "Camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
      await saveImage(image.path); // Save the image path
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Profile",
        firstIcon: Icons.category_outlined,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        gradient: LinearGradient(
                          colors: [
                            CommonColors.bottomIconColor,
                            CommonColors.bottomIconColor.withOpacity(0.8),
                            CommonColors.bottomIconColor.withOpacity(0.4),
                            CommonColors.bottomIconColor.withOpacity(0.4),
                            CommonColors.bottomIconColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: CommonColors.whiteColor,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 70,
                            child: ClipOval(
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : Image.network(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 200,
                    top: 120,
                    child: InkWell(
                      onTap: () {
                        selectImageOption();
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: CommonColors.containerIconB,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonColors.whiteColor, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.mode_edit_outline_outlined,
                            color: CommonColors.bottomIconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  userNameKey,
                  style: CommonStyle.getRalewayFont(
                    color: CommonColors.blackColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SettingListView(
                image: const [
                  LocalImages.icEdit,
                  // LocalImages.icSchedule,
                  LocalImages.icChart,
                  LocalImages.icSchedule,
                  // LocalImages.icLock,
                  // LocalImages.icSetting,
                  LocalImages.icLogout,
                ],
                text: const [
                  "Your Profile",
                  // "Schedule",
                  "Projects",
                  // "Change Password",
                  // "Setting",
                  "Tasks",
                  "Logout",

                ],
                selectIcon: true,
                onTap: (int index) {
                  if (index == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const UserInfo()),
                    );
                  } else if (index == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const UpcomingTaskView()),
                    );
                  } else if (index == 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const HomeView()),
                    );
                  }
                  else if (index == 3){
                    authService.signOut().whenComplete((){
                      nextScreenReplace(context,const LoginPage());
                    });
                  }
                },
              ),
              // const SizedBox(height: 20),
              // const SwitchListView(
              //   image: [
              //     LocalImages.icLocation,
              //     LocalImages.icEmail,
              //   ],
              //   text: [
              //     "Turn on Location",
              //     "Email Notification",
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void selectImageOption() async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: CommonColors.whiteColor,
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text(
                    "Camera",
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    chooseImage("Camera");
                  }),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(
                  "Gallery",
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  chooseImage("Gallery");
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
