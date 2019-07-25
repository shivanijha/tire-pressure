import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Animation animation, transformationAnim;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 8), vsync: this);

    animation = Tween(begin: 10.0, end: 200.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    transformationAnim = BorderRadiusTween(
        begin: BorderRadius.circular(150.0),
        end: BorderRadius.circular(0.0))
        .animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward();
    /// Initialize data, then navigator to Home screen.
    initData().then((value) {
      navigateToHomeScreen();
    });
  }


  @override
  Widget build(BuildContext context) {


    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return new Scaffold(
              body: new Center(
                child: new Stack(
                  children: <Widget>[
                    new Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: animation.value,
                        height: animation.value,
                        decoration: BoxDecoration(
                            borderRadius: transformationAnim.value,
                            color: Colors.orange,
                            image: DecorationImage(
                                image: AssetImage('assets/images/splash.png')
                            )
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }

  Future initData() async {
    //todo :: model building here --->
    buildMLModel();
    await Future.delayed(Duration(seconds: 5));
  }

  void navigateToHomeScreen() {
    /// Push home screen and replace (close/exit) splash screen.
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void buildMLModel() {}
}