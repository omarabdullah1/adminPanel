import 'dart:developer';
import 'package:adminpanel/layout/dashboard_layout/dashboard_layout.dart';
import 'package:adminpanel/shared/bloc_observer.dart';
import 'package:adminpanel/shared/network/local/cache_helper.dart';
import 'package:adminpanel/shared/network/remote/dio_helper.dart';
import 'package:adminpanel/shared/styles/themes.dart';
import 'package:adminpanel/translations/codegen_loader.g.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'layout/dashboard_layout/cubit/cubit.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await EasyLocalization.ensureInitialized();
  Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAcSAZkDsjBYGXuN1545nN5hzT_LaHBQS4",
        authDomain: "egyoutfit-a9d89.firebaseapp.com",
        projectId: "egyoutfit-a9d89",
        storageBucket: "egyoutfit-a9d89.appspot.com",
        messagingSenderId: "817925315934",
        appId: "1:817925315934:web:04ef187002fb77ded203cf",
        measurementId: "G-W1GVBR8ZEP"
    ),
  ).whenComplete(() {
    // Firebase.apps.forEach((element) {log(element.toString());});
    log("completed");
  });

  DioHelper.init();
  await CacheHelper.init();

  // widget = const OtpScreen();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/lang',
    assetLoader: const CodegenLoader(),
    fallbackLocale: const Locale('en'),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  const MyApp({Key key,}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit(),
        ),
        BlocProvider(
          create: (context) => DashboardCubit()
            ..changeLanguageValue(
                CacheHelper.getData(key: 'lang') != null
                    ? CacheHelper.getData(key: 'lang') == 'en'
                    ? true
                    : false
                    : true,
                context),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: lightTheme,
        // theme: lightTheme,
        // darkTheme: darkTheme,
        // themeMode: false ? ThemeMode.dark : ThemeMode.light,
        home: AnimatedSplashScreen(
          nextScreen: ShowCaseWidget(builder: Builder(builder:(context)=> const DashboardLayout()),),
          backgroundColor: Colors.white,
          duration: 1500,
          centered: true,
          splash: Image.asset('assets/images/logo black.png'),
          splashIconSize: 250,
        ),
      ),

    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;
}
