import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/create_task/create_task_view.dart';
import 'package:task/view/home/home_view.dart';
import 'package:task/view/inbox/inbox_view.dart';
import 'package:task/view/profile/profile_view.dart';
import 'package:task/view/upcoming_task/upcoming_task_view.dart';
import '../../allUsers/AllUsers.dart';
import 'bottom_nav_for_user_view_task.dart';

class BottomNavigationForTaskView extends StatefulWidget {
  final int selectedIndex;
  final String message;

  const BottomNavigationForTaskView(
      {super.key, required this.selectedIndex, required this.message});

  @override
  State<BottomNavigationForTaskView> createState() =>
      _BottomNavigationForTaskViewState();
}

class _BottomNavigationForTaskViewState
    extends State<BottomNavigationForTaskView> {
  BottomNavBarForTaskViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel =
          Provider.of<BottomNavBarForTaskViewModel>(context, listen: false);
      mViewModel?.attachContext(context);
      mViewModel?.selectedTab(widget.selectedIndex);
    });
  }

  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return const HomeView();
      case 1:
        return const UpcomingTaskView();
      case 2:
        return const AllUsers();
      case 3:
        return const ProfileView();
      default:
        return const Center(
          child: Text("Default"),
        );
    }
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<BottomNavBarForTaskViewModel>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: callPage(mViewModel?.currentIndex ?? 0),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: CommonColors.bottomIconColor,
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => const CreateTaskView(),
        //       ),
        //     );
        //   },
        //   tooltip: '',
        //   elevation: 4.0,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [
        //       Icon(
        //         Icons.add,
        //         size: 30,
        //       )
        //     ],
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),
          child: BottomNavigationBar(
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: CommonColors.whiteColor,
            currentIndex: mViewModel!.currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: CommonColors.blackColor,
            selectedLabelStyle: CommonStyle.getRalewayFont(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CommonColors.blackColor),
            unselectedLabelStyle: CommonStyle.getRalewayFont(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CommonColors.textGeryColor),
            onTap: (value) {
              mViewModel!.selectedTab(value);
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.transparent,
                icon: mViewModel!.currentIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icHouse,
                          height: 20,
                          width: 20,
                          color: CommonColors.bottomIconColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icHouse,
                          height: 20,
                          width: 20,
                          color: CommonColors.containerIconB,
                        ),
                      ),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.transparent,
                icon: mViewModel!.currentIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icCalendar,
                          height: 22,
                          width: 22,
                          color: CommonColors.bottomIconColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icCalendar,
                          height: 22,
                          width: 22,
                          color: CommonColors.containerIconB,
                        ),
                      ),
                label: "Projects",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.transparent,
                icon: mViewModel!.currentIndex == 2
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icInbox,
                          height: 20,
                          width: 20,
                          color: CommonColors.bottomIconColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icInbox,
                          height: 20,
                          width: 20,
                          color: CommonColors.containerIconB,
                        ),
                      ),
                label: "Users",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.transparent,
                icon: mViewModel!.currentIndex == 3
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icUser,
                          height: 22,
                          width: 22,
                          color: CommonColors.bottomIconColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          LocalImages.icUser,
                          height: 22,
                          width: 22,
                          color: CommonColors.containerIconB,
                        ),
                      ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
