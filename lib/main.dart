import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'layout/home_layout.dart';
import 'modules/onBoarding.dart';
import 'modules/shopLogin/cubit/cubit_observe.dart';
import 'modules/shopLogin/loginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
        ()async {
      DioHelper.init();
      await CacheHelper.init();
      Widget widget;
      bool? onBoarding = CacheHelper.getDat(key: 'onBoarding');
         token = CacheHelper.getDat(key: 'token');
         print(token);
      if(onBoarding != null){
        if(token != null){
          widget=const HomeLayoutScreen();
        }else{
          widget=const LoginPage();
        }
      }else{
        widget=OnBoardingScreen();
      }
      runApp( MyApp(startWidget: widget,));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
   MyApp({required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getHomeData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home:  startWidget,
      ),
    );
  }
}

