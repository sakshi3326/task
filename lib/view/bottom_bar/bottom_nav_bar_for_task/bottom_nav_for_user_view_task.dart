import 'package:flutter/cupertino.dart';

class BottomNavBarForTaskViewModel with ChangeNotifier {
  BuildContext? mContext;
  int currentIndex = 0;

  attachContext(BuildContext context) {
    mContext = context;
    attachIndex();
  }

  attachIndex() {
    currentIndex = 0;
    notifyListeners();
  }

  selectedTab(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
