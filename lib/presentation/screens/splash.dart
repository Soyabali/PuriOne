
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/verifyAppVersion.dart';
import '../complaints/complaintHomePage.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';

class SplashView extends StatefulWidget {

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplaceState();
}

class _SplaceState extends State<SplashView> {

  bool activeConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
          versionAliCall();
          //displayToast(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
        displayToast(T);
      });
    }
  }

  String? _appVersion ;

  // get app Version

  //url
  void _launchGooglePlayStore() async {
    const url = 'https://play.google.com/store/apps/details?id=com.instagram.android&hl=en_IN&gl=US'; // Replace <YOUR_APP_ID> with your app's package name
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUserConnection();
    // versionAliCall();
    getlocalDataBaseValue();
    print('---------xx--xxxxxx-------');
    super.initState();
  }
  getlocalDataBaseValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('sToken');
    print('----TOKEN---87---$token');
    if(token!=null && token!=''){
      print('-----89---HomeScreen');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ComplaintHomePage()),
            (Route<dynamic> route) => false, // This condition removes all previous routes
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ComplaintHomePage()),
      // );

    }else{
      print('-----91----LoginScreen');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen_2()),
            (Route<dynamic> route) => false, // This condition removes all previous routes
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginScreen_2()),
      // );
    }
  }
  versionAliCall() async{
    /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
    /// HERE YOU PASS variable _appVersion
    var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'1');
    var result = "${loginMap['Result']}";
    var msg = "${loginMap['Msg']}";
    // print('---73--$result');
    // print('---74--$msg');

    if(result=="1"){
     // LoginScreen_2
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const LoginScreen_2()),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>  const HomePage()),
      // );

      // displayToast(msg);
    }else{
      showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Version Available'),
            content: const Text('Download the latest version of the app from the Play Store.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _launchGooglePlayStore(); // Close the dialog
                },
                child: const Text('Downlode'),
              ),

            ],
          );
        },
      );
      displayToast(msg);
      //print('----F---');
    }
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
    );
  }
}

class SplaceScreen extends StatelessWidget {
  const SplaceScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomRight,
          children: [
            // Container(
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage(ImageAssets.templepuri4), // Replace 'background_image.jpg' with your image path
            //         fit: BoxFit.cover, // Cover the entire container
            //       ),
            //     ),
            //   ),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                     // Container(
                     //   child: Image.asset(ImageAssets.cityname,
                     //     height: 200,
                     //     width: 300,),
                     // ),
                     Positioned(
                         child: Text('Diu Citizen',
                           style:AppTextStyle.font30penSansExtraboldWhiteTextStyle,
                         ),
                     )
                ],
              )
            )

          ],
      )
    );
  }
}
