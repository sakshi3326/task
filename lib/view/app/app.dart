import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/app_strings.dart';
import 'package:task/view/bottom_bar/bottom_nav_bar_for_task/bottom_nav_for_user_view_task.dart';
import 'package:task/view/splash/splash_view.dart';
import 'app_view_model.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }

  const App({super.key});
}

final routeObserver = RouteObserver<PageRoute>();

class AppState extends State<App> with WidgetsBindingObserver {
  static BuildContext? appContext;
  final _app = AppModel();

  @override
  void initState() {
    super.initState();
    appContext = context;
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          value.isLoading = false;
          if (value.isLoading) {
            return Container(
              color: Theme.of(context).colorScheme.background,
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<BottomNavBarForTaskViewModel>(
                  create: (_) => BottomNavBarForTaskViewModel()),
            ],
            child: MaterialApp(
              scrollBehavior:
                  const ScrollBehavior().copyWith(overscroll: false),
              builder: (BuildContext context, Widget? child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                    data: data.copyWith(textScaleFactor: 1), child: child!);
              },
              title: AppStrings.appName,
              navigatorObservers: [routeObserver],
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/': (context) => const SplashView(),
              },
            ),
          );
        },
      ),
    );
  }
}
