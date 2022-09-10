import 'package:flutter/material.dart';
import 'package:tipitaka/settings_view.dart';
import 'package:tipitaka/suthra_list_view.dart';
import 'package:tipitaka/home_view.dart';
import 'package:tipitaka/item.dart';
import 'package:tipitaka/player_view.dart';
import 'package:tipitaka/splash_view.dart';
import 'package:tipitaka/text_view.dart';

class Routes {
  static const String startupView = '/';
  static const String homeView = '/home-view';

  static const String loginView = '/login-view';
  static const String outletView = '/outlet-view';
  static const String confirmView = '/confirm-view';
  static const String settingsView = '/settings-view';
  static const String playerView = '/player-view';
  static const String textView = '/suthra-text-view';
  static const String suthraListView = '/suthra-list-view';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.startupView:
      return _getPageRoute(
          routeName: settings.name, viewToShow: const SplashView());

    case Routes.homeView:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const HomeView(),
      );

    case Routes.suthraListView:
      Map map = settings.arguments as Map;
      Item data = map['arguments'];
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SuthraListView(
          item: data,
        ),
      );

    case Routes.playerView:
      //Item data = settings.arguments as Item;
      Map map = settings.arguments as Map;
      Item data = map['arguments'];
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PlayerView(
          item: data,
        ),
      );

    case Routes.textView:
      Map map = settings.arguments as Map;
      Item data = map['arguments'];
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TextView(
          item: data,
        ),
      );

    case Routes.settingsView:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const SettingsView(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

PageRoute _getPageRoute({String? routeName, required Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
