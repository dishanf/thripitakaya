import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:tipitaka/locator.dart';
import 'package:tipitaka/router.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();
  await ThemeManager.initialise();
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      statusBarColorBuilder: (theme) => theme?.backgroundColor,
      //themes: getThemes(),
      defaultThemeMode: ThemeMode.dark,
      lightTheme: ThemeData(
        brightness: Brightness.light,
        //backgroundColor: Colors.white,
        //primaryColor: Colors.white,
        /* buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blueGrey,
        ), */
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          button: TextStyle(
            color: Colors.black,
          ),
          subtitle1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        //primaryColor: Colors.black87,
        //backgroundColor: Colors.black87,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.greenAccent,
          textTheme: ButtonTextTheme.primary,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          button: TextStyle(
            color: Colors.white,
          ),
          subtitle1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        title: 'PresCap',
        initialRoute: Routes.startupView,
        onGenerateRoute: generateRoute,
        //darkTheme: ,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
