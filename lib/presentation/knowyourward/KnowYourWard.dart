import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/generalFunction.dart';
import '../../services/CitizenGetWardByLatLonRepo.dart';
import '../../services/GetWardDetailsRepo.dart';
import '../../services/bindCityzenWardRepo.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';

class KnowYourWard extends StatefulWidget {

  final name;
  final pageName;

  KnowYourWard({super.key, this.name, required this.pageName});

  @override
  State<KnowYourWard> createState() => _KnowYourWardState();
}

class _KnowYourWardState extends State<KnowYourWard> {

  // Date PICKER
  DateTime selectedDate = DateTime.now();
  GeneralFunction generalFunction = GeneralFunction();
  final _formKey = GlobalKey<FormState>();
  var pageName;
  File? image;
  List distList = [];
  var _dropDownValueDistric;
  List stateList = [];
  List blockList = [];
  List bindWard = [];
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>>? getWardDetail;
  List<Map<String, dynamic>> _filteredData = [];
  var _dropDownValueMarkLocation;
  var _selectedPointId;
  bool isLoading = true;
  var sWardName,sWardCode;

  // bindCitizenWard
  bindWardInDropDown() async {
    bindWard = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  bindWard 45---> $bindWard");
    setState(() {});
  }

  // bindValue
  bindCityzenData(lat, long) async {
    pendingInternalComplaintList = await CitizenGetWardbylatlongRepo()
        .citizenGetWardbyLatLong(context, lat, long);
    print(" -----45----ward Info -->>>>--XXX----> $pendingInternalComplaintList");
     sWardName = "${pendingInternalComplaintList![0]['sWardName']}";
     sWardCode = "${pendingInternalComplaintList![0]['sWardCode']}";
     /// todo call api GETward Detail
     print("-----50----$sWardName");
     print("-----51----$sWardCode");
     if(sWardCode!=null){
       /// todo call api GETward Detail
       getWardDetail = await GetWardDetailRepo().getWardDerail(context,sWardCode);
       print('------64---xx--$getWardDetail');
       _filteredData = List<Map<String, dynamic>>.from(getWardDetail ?? []);

     }



    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  /// Todo bind SubCategory
  Widget _bindSubCategory() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 25,
        height: 42,
        //color: Color(0xFFf2f3f5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Set the outline color
            width: 1.0, // Set the outline width
          ),
        ),

        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: TextSpan(
                  text: "Select Ward",
                  style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: AppTextStyle
                            .font14penSansExtraboldBlack45TextStyle),
                  ],
                ),
              ),
              // Not necessary for Option 1
              value: _dropDownValueMarkLocation,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueMarkLocation = newValue;
                  if(_dropDownValueMarkLocation!=null){
                    /// todo call a api
                    print('-----111---$_dropDownValueMarkLocation');

                  }
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  bindWard.forEach((element) {
                    if (element["sWardName"] == _dropDownValueMarkLocation) {
                      setState(() {
                        _selectedPointId = element['sWardCode'];
                        print('----341------$_selectedPointId');
                      });
                      print('-----Point id----241---$_selectedPointId');
                      if (_selectedPointId != null) {
                        // updatedBlock();
                        print('-----Point id----244---$_selectedPointId');
                      } else {
                        print('-------');
                      }
                      // print("Distic Id value xxxxx.... $_selectedDisticId");
                      print("Distic Name xxxxxxx.... $_dropDownValueDistric");
                      print("Block list Ali xxxxxxxxx.... $blockList");
                    }
                  });
                });
              },
              items: bindWard.map((dynamic item) {
                return DropdownMenuItem(
                  value: item["sWardCode"].toString(),
                  // child: Text(item['sWasteType'].toString()),
                  child: Container(
                    width: 280, // Set an appropriate width based on your UI
                    child: Text(
                      item['sWardName'].toString(),
                      maxLines: 2,
                      // Allows up to 2 lines
                      overflow: TextOverflow.ellipsis,
                      // Shows "..." if text is too long
                      softWrap: true, // Allows text wrapping
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // location code
  // takeaLocation
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      bindCityzenData(lat, long);
      // if(lat && long !=null){
      //   // call a api functin
      //   print("-------location---xxx----");
      //
      // }else{
      //   print('---LOCATION IS NOT PICK----');
      // }
    });

    /// TODO HERE YOU SHOULD CALL A API WITH THE BEHAGE OF LAN AND LONG GET A RELATED INFO.

    print('-----------139----$lat');
    print('-----------140----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

  @override
  void initState() {
    print('-----27--${widget.name}');
    pageName = "${widget.pageName}";
    getLocation();
    bindWardInDropDown();
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context, '$pageName'),
        // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body: isLoading
            ? Center(child: Container())
            : (getWardDetail == null ||
              getWardDetail!.isEmpty)
                ? NoDataScreenPage()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        //  Center(
                        //  child: Padding(
                        //      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5.0),
                        //       border: Border.all(
                        //         color: Colors.grey, // Outline border color
                        //         width: 0.2, // Outline border width
                        //       ),
                        //       color: Colors.white,
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: TextFormField(
                        //             controller: _searchController,
                        //             autofocus: true,
                        //             decoration: const InputDecoration(
                        //               prefixIcon: Icon(Icons.search),
                        //               hintText: 'Enter Keywords',
                        //               hintStyle: TextStyle(
                        //                   fontFamily: 'Montserrat',
                        //                   color: Color(0xFF707d83),
                        //                   fontSize: 14.0,
                        //                   fontWeight: FontWeight.bold),
                        //               border: InputBorder.none,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // ),
                        // scroll item after search bar
                        Expanded(
                            child: ListView.builder(
                                itemCount: _filteredData.length ?? 0,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> item = _filteredData[index];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Card(
                                          elevation: 4,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  _bindSubCategory(),
                                                  SizedBox(height: 10),
                                                  // to Draw ui of Know Your Ward
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0,
                                                                right: 10),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration:
                                                              const BoxDecoration(
                                                            border: Border(
                                                              left: BorderSide(
                                                                  color: Colors
                                                                      .green,
                                                                  width:
                                                                      4), // Left border
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            // Align text to start (left)
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            // Wrap content instead of expanding
                                                            children: <Widget>[
                                                              Text(
                                                                "PRALAYA BEURA",
                                                                style: AppTextStyle
                                                                    .font14penSansExtraboldBlackTextStyle,
                                                              ),
                                                              Text(
                                                                "Party Name :-BJD",
                                                                style: AppTextStyle
                                                                    .font14penSansExtraboldBlack45TextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  // Contact No
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Contact No",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                          Text("9438174886",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Agency Name",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                          Text("Not Specified",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Center(
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          // Rounded rectangle border
                                                          radius:
                                                              Radius.circular(
                                                                  4),
                                                          // Rounded corners
                                                          dashPattern: [4, 4],
                                                          // Dotted effect
                                                          color: Colors.grey,
                                                          // Dotted border color
                                                          strokeWidth: 2,
                                                          // Thickness of dots
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            // Padding inside the container
                                                            alignment: Alignment
                                                                .center,
                                                            // Center the text
                                                            child: Text(
                                                              "Ward no - 46",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Description Of Ward",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                          Text(
                                                              "Bada Jobra(P),Kalia Boda,Guru Kshetra ,",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Address",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                          Text("Not Specified",
                                                              style: AppTextStyle
                                                                  .font14penSansExtraboldBlackTextStyle),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  );
                                }))
                      ]));
  }
}
