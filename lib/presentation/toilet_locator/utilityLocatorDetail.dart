import 'dart:io';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:puri/app/generalFunction.dart';
import 'package:puri/model/toiletListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/loader_helper.dart';
import '../../app/navigationUtils.dart';
import '../../services/GetNearByPlaceListRepo2.dart';
import '../../services/toiletListRepo.dart';
import '../fullscreen/imageDisplay.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import '../temples/templeGoogleMap.dart';


class UtilityLocatorDetail extends StatefulWidget {

  final publicUtilityName;
  final iTypeCode;
  final lat;
  final long;
  const UtilityLocatorDetail({super.key,
    required this.publicUtilityName,
    required this.iTypeCode,
    required this.lat,
    required this.long});

  @override
  State<UtilityLocatorDetail> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<UtilityLocatorDetail> with WidgetsBindingObserver {
  // final todos;
  dynamic? lat,long;
  dynamic? lat2,long2;
  double? fLatitude;
  double? fLongitude;
  var image;
  bool isLoading = true;
  List<ToiletListModel>? templeListResponse;
  bool _isLocationPermanentlyDenied = false;
  bool _toastDisplayed = false;
  List<Map<String, dynamic>>? utilitylocatorList;
  List<Map<String, dynamic>>? _filteredData;
  var iTypeCodeUtilities;

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];

  Color getRandomBorderColor() {
    final random = Random();
    return borderColors[random.nextInt(borderColors.length)];
  }

  Future<void> _getLocation(BuildContext context) async {
    // showLoader();
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hideLoader();
      displayToast('Location services are disabled.');
      await Geolocator.openLocationSettings();
      return;
    }
    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      hideLoader();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        hideLoader();
        displayToast('Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      hideLoader();
      // Ensure the loader is hidden immediately
      _isLocationPermanentlyDenied = true;
      // Save _isLocationPermanentlyDenied state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLocationPermanentlyDenied', _isLocationPermanentlyDenied);
      // Show dialog if permissions are permanently denied
      if (!_toastDisplayed) {
        hideLoader();
        _showPermissionsDialog(context);
        _toastDisplayed = true; // Mark toast as displayed
      }
      return;
    }
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    // Handle location data
    if (lat != null && long != null) {
      hideLoader();
      // Call your API or perform other location-dependent actions

      fetchToiletList(lat, long);
    } else {
      hideLoader();
      displayToast('Failed to retrieve location');
    }
  }

  void displayToast(String message) {
    // Implement your toast message display here
    print(message);
  }
  void _showPermissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content: Text('Please enable location permissions in settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearAppData();
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAppData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;

      await Process.run('pm', ['clear', packageName]);
    } else if (Platform.isIOS) {
      // iOS does not provide a way to programmatically clear app data. You might need to instruct the user to do it manually.
      displayToast('Please clear app data manually in iOS settings.');
    }
  }

  // Utility Locator Detail
  utilityLocator(lat2, long2, iTypeCodeUtilities) async {
    utilitylocatorList = await GetNearByPlaceListRepo2().getNearByPlacelist(context,lat2,long2,iTypeCodeUtilities);
    print('-----142----xx --getNearByPlaceList----$utilitylocatorList');
    _filteredData = List<Map<String, dynamic>>.from(utilitylocatorList ?? []);
    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  Future<void> fetchToiletList(double lat2, double long2,) async {
    print('---40---$lat2');
    print('---41---$long2');
    ToiletListRepo templeListRepo = ToiletListRepo();
    List<ToiletListModel>? templeList = await templeListRepo.getbyToilet(context,lat2,long2);
    if (templeList != null) {
      // Iterate through the list and print specific fields
      for (var temple in templeList) {
        print('Temple Name: ${temple.sToiletName}');
        print('Location: ${temple.sLocation}');
        print('Image URL: ${temple.sImage}');
        print('Distance: ${temple.sDistance}');
        print('------------------');
      }
      setState(() {
        templeListResponse = templeList;
        isLoading = false;
      });
    } else {
      print('Error: Failed to fetch temple list');
      // Optionally, show a message to the user or retry fetching data
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print('lat-----xxxxxxxxxxxxxx-----243---$_isLocationPermanentlyDenied');
    WidgetsBinding.instance.addObserver(this);
    _getLocation(context);

    iTypeCodeUtilities = "${widget.iTypeCode}";
    lat2 = "${widget.lat}";
    long2 = "${widget.long}";
    utilityLocator(lat2,long2,iTypeCodeUtilities);


    super.initState();
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Call your API or get location when the app resumes
      // getLocation();
      _getLocation(context);
    }
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    NavigationUtils.onWillPop(context);
    return true;
  }
  // GeneralFunction? generalFunction;
  GeneralFunction generalFunction = GeneralFunction();

  void _navigateToMap(BuildContext context, double? fLatitude, double? fLongitude, String locationName, String sLocationAddress) {
    if (fLatitude != null && fLongitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TempleGoogleMap(
            fLatitude: fLatitude,
            fLongitude: fLongitude,
            locationName: locationName,
            sLocationAddress: sLocationAddress,
          ),
        ),
      );
    } else {
      print("Latitude or Longitude is null");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,'${widget.publicUtilityName}'),
      // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: _isLocationPermanentlyDenied
          ? const Padding(
        padding: EdgeInsets.only(left: 15, top: 10),
        child: Text(
          "Location permissions are permanently denied. You should reinstall the application or clear the application's storage on your phone.",
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
              itemCount: utilitylocatorList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final color = borderColors[index % borderColors.length];
                // ToiletListModel temple = templeListResponse![index];
                Map<String, dynamic> item = utilitylocatorList![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              print('---click images---');
                              // String image = temple.sImage;
                              var image =  utilitylocatorList![index]['sImage'];
                              print('---Images----160---$image');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImages(image: image),
                                ),
                              );
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(
                                  utilitylocatorList![index]['sImage'],
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover, // Ensures the image covers the whole box properly
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, size: 45, color: Colors.grey);
                                  },
                                ),
                              ),
                            ),
                            // child:Container(
                            //   height: 90,
                            //   width: 90,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(4.0),
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(5.0),
                            //       child: Image.network(
                            //         utilitylocatorList![index]['sImage'],
                            //         height: 70,
                            //         width: 70,
                            //         fit: BoxFit.cover, // Ensures the image covers the whole box properly
                            //         errorBuilder: (context, error, stackTrace) {
                            //           return Icon(Icons.broken_image, size: 45, color: Colors.grey);
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                           width: 230,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Text(
                                 // temple.sToiletName,
                                 utilitylocatorList![index]['sPlaceName'],
                                 style: AppTextStyle.font12penSansExtraboldBlack45TextStyle,
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                               SizedBox(height: 2),
                               Text(
                                 // temple.sToiletName,
                                 utilitylocatorList![index]['sLocation'],
                                 style: AppTextStyle.font12penSansExtraboldBlack45TextStyle,
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                               SizedBox(height: 2),
                               Text(
                                 // temple.sToiletName,
                                 utilitylocatorList![index]['sDistance'],
                                 style: AppTextStyle.font12penSansExtraboldBlack45TextStyle,
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                               ),


                             ],
                           ),
                         ),


                        Spacer(),


                        // Expanded(
                        //   child: Container(
                        //     height: 80,
                        //     child: Padding(
                        //       padding: EdgeInsets.only(top: 10),
                        //       child: Padding(
                        //         padding: EdgeInsets.only(left: 10),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.only(top: 8),
                        //               child: Text(
                        //                // temple.sToiletName,
                        //                 utilitylocatorList![index]['sTypeName'],
                        //                 style: GoogleFonts.openSans(
                        //                   color: AppColors.green,
                        //                   fontSize: 14,
                        //                   fontWeight: FontWeight.w600,
                        //                   fontStyle: FontStyle.normal,
                        //                 ),
                        //                 maxLines: 1,
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ),
                        //             // Row(
                        //             //   mainAxisAlignment: MainAxisAlignment.start,
                        //             //   children: <Widget>[
                        //             //     Text(
                        //             //       'Distance :',
                        //             //       style: GoogleFonts.openSans(
                        //             //         color: AppColors.green,
                        //             //         fontSize: 12,
                        //             //         fontWeight: FontWeight.w600,
                        //             //         fontStyle: FontStyle.normal,
                        //             //       ),
                        //             //     ),
                        //             //     SizedBox(width: 5),
                        //             //     Text(
                        //             //       //temple.sDistance,
                        //             //       '2019',
                        //             //       style: GoogleFonts.openSans(
                        //             //         color: AppColors.red,
                        //             //         fontSize: 12,
                        //             //         fontWeight: FontWeight.w600,
                        //             //         fontStyle: FontStyle.normal,
                        //             //       ),
                        //             //     ),
                        //             //   ],
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        /// todo next page open this is a directional link on a map
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //
                        //         var publicUtilityName =  utilitylocatorList![index]['sPlaceName'];
                        //         print("------394---$publicUtilityName");
                        //
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(right: 10),
                        //         child: Image.asset(
                        //           'assets/images/arrow.png',
                        //           height: 12,
                        //           width: 12,
                        //           color: color,
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              fLatitude;
                              fLongitude;
                              // sLocation
                              if (utilitylocatorList![index]['fLatitude'] is String) {
                                //fLatitude = double.parse(templeListResponse![index]['fLatitude']);
                                // fLatitude = double.parse(temple.fLatitude);
                              } else {
                                fLatitude = utilitylocatorList![index]['fLatitude'];
                                //fLatitude = temple.fLatitude;
                              }

                              if (utilitylocatorList![index]['fLongitude'] is String) {
                                // fLongitude = double.parse(templeListResponse![index]['fLongitude']);
                              } else {
                                fLongitude = utilitylocatorList![index]['fLongitude'];
                              }
                              var locationName = utilitylocatorList![index]['sPlaceName'];
                              var sLocationAddress = utilitylocatorList![index]['sLocation'];
                              print('-----336---fLatitude--$fLatitude');
                              print('-----337---fLongitude--$fLongitude');
                              print('-----338---locationName--$locationName');
                              print('-----338---sLocation--$sLocationAddress');

                              _navigateToMap(context, fLatitude, fLongitude, locationName, sLocationAddress);

                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                'assets/images/direction.jpeg',
                                height: 25,
                                width: 25,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),










                        // Padding(
                        //   padding: const EdgeInsets.only(right: 5),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       Align(
                        //         alignment: Alignment.topRight,
                        //         child: Image.asset(
                        //           "assets/images/listelementtop.png",
                        //           height: 25,
                        //           width: 25,
                        //         ),
                        //       ),
                        //       SizedBox(height: 35),
                        //       Align(
                        //         alignment: Alignment.bottomRight,
                        //         child: Image.asset(
                        //           "assets/images/listelementbottom.png",
                        //           height: 25,
                        //           width: 25,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class NoDataScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No data found'),
    );
  }
}

