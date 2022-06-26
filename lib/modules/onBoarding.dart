import 'package:flutter/material.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'shopLogin/loginScreen.dart';

class PageMode {
  final String img;
  final String title;
  final String body;
  PageMode({
    required this.title,
    required this.body,
    required this.img,
  });
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var control = PageController();

  bool isLast = false;

  List model = [
    PageMode(
        title: 'ORDER ONLINE',
        body:
            'Make an order sitting on a sofa.\n        Pay and choose online.',
        img: 'assets/images/page1.png'),
    PageMode(
        title: 'MOBILE PAYMENTS',
        body:
            'Download our shopping application\n    and buy using your smartphone.',
        img: 'assets/images/page2.png'),
    PageMode(
        title: 'DELIVERY SERVICE',
        body:
            'Modern delivering technologies.\n    Shipping to the porch of you\n                 apartments.',
        img: 'assets/images/page3.png'),
  ];
  String text='';

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
      navigateAndFinish(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            onPressed: () {
              submit();
            },
            text: 'skip',
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: PageView.builder(
            controller: control,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildOnBoardItem(model[index]),
            itemCount: model.length,
            onPageChanged: (int index) {
              if (index == model.length - 1) {
                setState(() {
                  isLast = true;
                });
              } else {
                setState(() {
                  isLast = false;
                });
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SmoothPageIndicator(
          controller: control,
          count: model.length,
          effect: const ExpandingDotsEffect(
              activeDotColor: defaultColor,
              dotColor: Color.fromRGBO(230, 179, 230, 1),
              dotWidth: 10.0,
              dotHeight: 10.0,
              expansionFactor: 4.0,
              spacing: 5.0),
        ),
        const SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
            style: TextButton.styleFrom(
              fixedSize: Size(160.0, 40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (isLast) {
                submit();
              } else {
                control.nextPage(
                  duration: const Duration(
                    milliseconds: 750,
                  ),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              }
            },
            child: isLast ?const Text(
              'Start !',
              style: TextStyle(color: Colors.white),
            ):const Text(
              'Next',
              style: TextStyle(color: Colors.white),
            )
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }

  Widget buildOnBoardItem(PageMode model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.img),
            fit: BoxFit.fitWidth,
          ),
        ),
        Text(
          model.title,
          style: const TextStyle(
            fontSize: 22,
            color: defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Text(
            model.body,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
