import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/resources/app_strings.dart';
import 'package:puri/resources/assets_manager.dart';
import '../app/navigationUtils.dart';
import '../complaints/complaintHomePage.dart';
import '../presentation/helpline_feedback/helplinefeedback.dart';
import '../presentation/toilet_locator/toilet_locator.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import '../temples/nearbyplace/nearbyplace.dart';
import '../temples/templehome.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isTextVisible2 = false;
  bool isTextVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    NavigationUtils.onWillPop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:Stack(
          fit: StackFit.expand,
          children: <Widget>[
           Container(
                width: MediaQuery.of(context).size.width-50,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(ImageAssets.templepuri4,
                fit: BoxFit.cover,),
              ),
            Positioned(
              top: 70,
                right: 10,
                left: 10,
                child: Center(
                  child: Container(
                     child: Stack(
                       children: <Widget>[
                         Image.asset(ImageAssets.cityname,
                             height: 180),
                                 Positioned(
                                   top: 65,
                                   left: 100,
                                   child: Text(AppStrings.puriOne,
                                     style: AppTextStyle.font30penSansExtraboldWhiteTextStyle
                                   )

                                 )

                       ],
                     )
                  ),
                )
            ),
            // circle
            Positioned(
              top: 280,
              left: 15,
              right: 15,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double containerSize = constraints.maxWidth;
                  return Container(
                    height: containerSize,
                    width: containerSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(containerSize / 2), // Make it circular
                      image: const DecorationImage(
                        image: AssetImage(ImageAssets.changecitybackground), // Provide your image path here
                        fit: BoxFit.cover, // Cover the entire container
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: containerSize * 0.47,
                          left: containerSize * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "SELECT",
                              style: AppTextStyle.font10penSansExtraboldWhiteTextStyle,
                            ),
                          ),
                        ),
                        Positioned(
                             top: containerSize * 0.09,
                            left: containerSize * 0.40,
                          child: InkWell(
                            onTap: () {
                              print('-----114-----'); // HelpLineFeedBack
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => TemplesHome()));
                            },
                            child: Container(
                              width: containerSize * 0.2,
                              height: containerSize * 0.2,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'About',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                  Text(
                                    'Puri',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: containerSize * 0.35,
                          left: containerSize * 0.07,
                          child: InkWell(
                            onTap: () {
                              print('-----114-----'); // HelpLineFeedBack

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ToiletLocator(name: "Toilet Locator")),
                              );
                            },
                            child: Container(
                              width: containerSize * 0.2,
                              height: containerSize * 0.2,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Utility',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                  Text(
                                    'Locator',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: containerSize * 0.35,
                            right: containerSize * 0.06,
                            left: containerSize * 0.75,
                          child: InkWell(
                            onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ComplaintHomePage()),
                                    );
                            },
                            child: Container(
                              width: containerSize * 0.2,
                              height: containerSize * 0.2,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Citizen',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                  Text(
                                    'Services',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: containerSize * 0.12,
                          right: containerSize * 0.18,
                          child: InkWell(
                            onTap: () {
                              print('----130------');

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HelpLineFeedBack(name:"Help Line", image: '',)),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => NearByPlace(name:"Near by Place")),
                              // );
                            },
                            child: Container(
                              width: containerSize * 0.2,
                              height: containerSize * 0.2,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'Help Line',
                                style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: containerSize * 0.12,
                            left: containerSize * 0.20,
                          child: InkWell(
                            onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NearByPlace(name:"Near by Place")),
                                    );
                            },
                            child: Container(
                              width: containerSize * 0.2,
                              height: containerSize * 0.2,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Near by',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                  Text(
                                    'Place',
                                    style: AppTextStyle.font14penSansExtraboldWhiteTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),

                  );
                },
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 15.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Synergy Telmatics Pvt.Ltd.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'assets/images/favicon.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Padding(
            //       padding: EdgeInsets.only(bottom: 5.0, left: 15),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: <Widget>
            //         [
            //           Text(
            //             'Synergy Telmatics Pvt.Ltd.',
            //             style: AppTextStyle.font18penSansExtraboldWhiteTextStyle,
            //           ),
            //           SizedBox(width: 10),
            //           Padding(
            //             padding: EdgeInsets.only(right: AppSize.s10),
            //             child: SizedBox(
            //               width: 30,
            //               height: 30,
            //               child: Image.asset(
            //                 'assets/images/favicon.png',
            //                 width: 30,
            //                 height: 30,
            //                 fit: BoxFit.fill, // Changed BoxFit to fill
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
      );
  }
}

