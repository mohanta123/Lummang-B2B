import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_store/AppTheme/AppStateNotifier.dart';
import 'package:my_store/AppTheme/appTheme.dart';
import 'package:my_store/AppTheme/my_behaviour.dart';
import 'package:my_store/functions/change_language.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/home/home.dart';
import 'package:my_store/pages/login_signup/login.dart';
import 'package:my_store/pages/kyc/kyc.dart';
import 'package:my_store/pages/splash_screen.dart';
import 'package:provider/provider.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      ChangeNotifierProvider<AppStateNotifier>(
        create: (_) => AppStateNotifier(),
        child: MyApp(
          appLanguage: appLanguage,
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return ChangeNotifierProvider<AppLanguage>(
          create: (_) => appLanguage,
          child: Consumer<AppLanguage>(builder: (context, model, child) {
            return MaterialApp(
              title: 'MyStore',
              debugShowCheckedModeBanner: false,
              locale: model.appLocal,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('hi', ''),
                Locale('ar', ''),
                Locale('zh', ''),
                Locale('id', ''),
                Locale('ru', ''),
                Locale('es', ''),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: child,
                );
              },
              home: MyHomePage(),
              // home: KYCPage(),
              routes: {
                "loginScreen": (context) => OTPLoginPage(),
                "home": (context) => Home(),

              },
            );
          }),
        );
      },
    );
  }
}
