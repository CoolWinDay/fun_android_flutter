import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android/config/router_config.dart';

import 'package:wan_android/config/resource_mananger.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _logoController;
  Animation<double> _animation;
  AnimationController _countdownController;

  @override
  void initState() {
    _logoController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.easeInOutBack, parent: _logoController));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _logoController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _logoController.forward();
      }
    });
    _logoController.forward();

    _countdownController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _countdownController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(ImageHelper.wrapAssets('splash_bg.png'),
              fit: BoxFit.fill),
          AnimatedFlutterLogo(
            animation: _animation,
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnimatedAndroidLogo(
                  animation: _animation,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: InkWell(
                onTap: () {
                  nextPage(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black.withAlpha(100),
                  ),
                  child: AnimatedCountdown(
                    animation: StepTween(begin: 4, end: 0)
                        .animate(_countdownController),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class AnimatedCountdown extends AnimatedWidget {
  final Animation<int> animation;

  AnimatedCountdown({key, this.animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    var value = animation.value;
    return Text(
      (value == 0 ? '' : '$value | ') + '跳过',
      style: TextStyle(color: Colors.white),
    );
  }
}

class AnimatedFlutterLogo extends AnimatedWidget {
  AnimatedFlutterLogo({
    Key key,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedAlign(
      duration: Duration(milliseconds: 10),
      alignment: Alignment(0, 0.2 + animation.value * 0.3),
      curve: Curves.bounceOut,
      child: Image.asset(
        ImageHelper.wrapAssets('splash_flutter.png'),
        width: 280,
        height: 120,
      ),
    );
  }
}

class AnimatedAndroidLogo extends AnimatedWidget {
  AnimatedAndroidLogo({
    Key key,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          ImageHelper.wrapAssets('splash_fun.png'),
          width: 140 * animation.value,
          height: 80 * animation.value,
        ),
        Image.asset(
          ImageHelper.wrapAssets('splash_android.png'),
          width: 200 * (1 - animation.value),
          height: 80 * (1 - animation.value),
        ),
      ],
    );
  }
}

const firstEntry = 'firstEntry';

void nextPage(context) {
//  Route nextRoute = sharedPreferences.getBool(firstEntry) ?? true
//      ? SizeRoute(GuidePage())
//      : SizeRoute(LoginPage());
  Navigator.of(context).pushReplacementNamed(RouteName.tab);
}

class GuidePage extends StatefulWidget {
  static const List<String> images = <String>[
    'guide_page_1.png',
    'guide_page_2.png',
    'guide_page_3.png',
    'guide_page_4.png'
  ];

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        alignment: Alignment(0, 0.87),
        children: <Widget>[
          Swiper(
              itemBuilder: (ctx, index) => Image.asset(
                    'assets/images/${GuidePage.images[index]}',
                    fit: BoxFit.fill,
                  ),
              itemCount: GuidePage.images.length,
              loop: false,
              onIndexChanged: (index) {
                setState(() {
                  curIndex = index;
                });
              }),
          Offstage(
            offstage: curIndex != GuidePage.images.length - 1,
            child: CupertinoButton(
              color: Theme.of(context).primaryColorDark,
              child: Text('点我开始'),
              onPressed: () {
                SharedPreferences.getInstance()
                    .then((sp) => sp.setBool(firstEntry, false));
                nextPage(context);
              },
            ),
          )
        ],
      ),
    ));
  }
}
