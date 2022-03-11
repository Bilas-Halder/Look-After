import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:look_after/screens/Chat/chat_screen.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';
import 'package:look_after/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class OnBoardingPage extends StatefulWidget {
  static const String path = '/';
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  dynamic prefs;
  bool isBack, isSignedIn;

  @override
  void initState() {
    // TODO: implement initState
    // getIsBack();
    super.initState();
  }
  void getIsBack () async {
    prefs = await SharedPreferences.getInstance();
    isBack = prefs.getBool('isBack');
    isSignedIn = prefs.getBool('signedIn');
    print(isBack.toString()+'..............................................');
  }
  void setIsBack () async {
    await prefs.setBool('isBack', true);
    await getIsBack();

    print(isBack.toString()+'..............................................');
  }


  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, WelcomeScreen.path);
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    ///code for going to home/login screen.
    // if(isBack==null || isBack==false){
    //   setIsBack();
    //   getIsBack();
    // }
    // else if(isSignedIn==null || isSignedIn==false){
    //   Navigator.pushReplacementNamed(context, WelcomeScreen.path);
    // }
    // else{
    //   Navigator.pushReplacementNamed(context, ChatScreen.path);
    // }


    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        globalFooter: Container(
          width: double.infinity,
          height: 60,
          color: Colors.teal[600],
          child: MaterialButton(
            child : Text(
              'Let\s go right away!',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Welcome to Look After",
            body:
            "This is a task scheduling app with context awareness.",
            image: _buildImage('images/img1.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Save your regular tasks",
            body:
            "Save your everyday tasks too so we can notify you everyday and you will never be late for any work.",
            image: _buildImage('images/img2.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Secure online & offline Database",
            body:
            "We offer fully secure database with double protection system.",
            image: _buildImage('images/img3.jpg'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}