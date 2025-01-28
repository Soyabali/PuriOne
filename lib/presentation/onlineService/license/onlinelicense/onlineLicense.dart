import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/services/SearchLicenseForPaymentRepo.dart';

import '../../../../app/generalFunction.dart';
import '../../../../services/SearchPropertyTaxForPaymentRepo.dart';
import '../../../../services/bindCityzenWardRepo.dart';
import '../../../circle/circle.dart';
import '../../../nodatavalue/NoDataValue.dart';
import '../../../resources/app_text_style.dart';
import '../../../resources/values_manager.dart';

class Onlinelicense extends StatefulWidget {
  final name;
  const Onlinelicense({super.key, required this.name});

  @override
  State<Onlinelicense> createState() => _PropertyTaxState();
}

class _PropertyTaxState extends State<Onlinelicense> {
  GeneralFunction generalFunction = GeneralFunction();

  List<dynamic> wardList = [];
  var _dropDownWard;

  //
  TextEditingController _houseController = TextEditingController();
  TextEditingController _houseOwnerName = TextEditingController();

  FocusNode _housefocus = FocusNode();
  FocusNode _houseOwnerfocus = FocusNode();
  //
  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;

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

  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse(selectedWardId, String licenseRequestID, String mobileNo) async {
    emergencyTitleList = await SearchLicenseForPaymentRepo()
        .searchLicenseForPayment(context,selectedWardId,licenseRequestID,mobileNo);
    print('------56---xx------$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }

  // online title
  var OnlineTitle = [
    "Property Tax",
    "Building Plan",
    "Property Assessment",
    "License",
    "Community Hall",
    "Water Supply",
    "Electricity Bill",
    "Mamlatdar Diu"
  ];

  var _selectedWardId;
  // dropDown
  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }

  // bind
  Widget _bindWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 42,
          color: Color(0xFF255898), // Background color
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true, // Reduces the vertical size of the button
                isExpanded:
                    true, // Allows the DropdownButton to take full width
                dropdownColor:
                    Colors.grey, // Set dropdown list background color
                iconEnabledColor:
                    Colors.white, // Icon color (keeps the icon white)
                hint: RichText(
                  text: TextSpan(
                    text: "Select Ward",
                    style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                  ),
                ),
                value: _dropDownWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWard = newValue;
                    wardList.forEach((element) {
                      if (element["sWardName"] == _dropDownWard) {
                        _selectedWardId = element['sWardCode'];
                      }
                    });
                    print("------99-----$_selectedWardId");
                  });
                },
                style:
                    TextStyle(color: Colors.white), // Selected item text color
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors
                                    .white), // Dropdown menu item text color
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    bindWard();
    _housefocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _housefocus.dispose();
    _houseController.dispose();
    _houseOwnerfocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: getAppBarBack(context, '${widget.name}'),
          drawer: generalFunction.drawerFunction(
              context, 'Suaib Ali', '9871950881'),
          body: Column(
            children: [
              SizedBox(height: 5),
              _bindWard(),
              SizedBox(height: 10),
              // EditText
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Expanded(
                            child: TextFormField(
                          focusNode:
                              _housefocus, // Focus node for the text field
                          controller:
                              _houseController, // Controller to manage the text field's value
                          textInputAction: TextInputAction
                              .next, // Set action for the keyboard
                          onEditingComplete: () => FocusScope.of(context)
                              .nextFocus(), // Move to next input on completion
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Add a border around the text field
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ), // Adjust padding inside the text field
                            filled:
                                true, // Enable background color for the text field
                            fillColor:
                                Color(0xFFf2f3f5), // Set background color
                            hintText:
                                "License Request Id", // Placeholder text when field is empty
                            hintStyle: TextStyle(
                                color: Colors
                                    .grey), // Style for the placeholder text
                          ),
                          autovalidateMode: AutovalidateMode
                              .onUserInteraction, // Enable validation on user interaction
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Text("or",
                    style: AppTextStyle.font16OpenSansRegularBlack45TextStyle),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Expanded(
                            child: TextFormField(
                          focusNode:
                              _houseOwnerfocus, // Focus node for the text field
                          controller:
                              _houseOwnerName, // Controller to manage the text field's value
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction
                              .next, // Set action for the keyboard
                          onEditingComplete: () => FocusScope.of(context)
                              .nextFocus(), // Move to next input on completion
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Add a border around the text field
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ), // Adjust padding inside the text field
                            filled:
                                true, // Enable background color for the text field
                            fillColor:
                                Color(0xFFf2f3f5), // Set background color
                            hintText:
                                "Mobile NO", // Placeholder text when field is empty
                            hintStyle: TextStyle(
                                color: Colors
                                    .grey), // Style for the placeholder text
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                LengthLimitingTextInputFormatter(10), // Restrict input to a maximum of 10 digits
                              ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Your onTap logic here

                    var licenseRequestID = _houseController.text.trim();
                    var mobileNo = _houseOwnerName.text.trim();
                    print("----Selected Ward-----236---$_selectedWardId");
                    print("----houseno----240---$licenseRequestID");
                    print("----houseOwnerName-----241---$mobileNo");
                    if (_selectedWardId != null &&
                            _selectedWardId != "" &&
                        licenseRequestID.isNotEmpty ||
                        mobileNo.isNotEmpty) {
                      print("---Call APi---");

                      getEmergencyTitleResponse(_selectedWardId, licenseRequestID, mobileNo);

                    } else {
                      print("---Not Call APi---");
                      displayToast("Please enter the required details.");
                    }

                    // getEmergencyTitleResponse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF255898), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppMargin.m10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal:
                          AppPadding.p20, // Horizontal padding for spacing
                      vertical: AppPadding.p10, // Vertical padding for height
                    ),
                    elevation: 2, // Add slight elevation for the button
                  ),
                  child: Text(
                    "SEARCH",
                    style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 5),
              isLoading
                  ? Center(child: Container())
                  : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
                      ? NoDataScreenPage()
                      : Container(
                          //height: MediaQuery.of(context).size.height * 0.8,
                          child: Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: emergencyTitleList?.length ?? 0,
                                // itemCount: OnlineTitle?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final color =
                                      borderColors[index % borderColors.length];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                    0xFFD5E6FA), // Hex color #d5e6fa
                                                borderRadius: BorderRadius.circular(
                                                    10), // Optional: Rounded corners
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Center(
                                                      child: Container(
                                                        width:
                                                            50, // Width of the container
                                                        height:
                                                            50, // Height of the container
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .grey, // Gray background
                                                          shape: BoxShape
                                                              .circle, // Circular shape
                                                        ),
                                                        child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  color, // Set the dynamic color
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: const Icon(
                                                              Icons.ac_unit,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            emergencyTitleList![
                                                                    index]
                                                                ['sLicenseRequestNo'].toString(),
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlackTextStyle,
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "License Request Id",
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlack45TextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //           right: 0, top: 10),
                                                  //   child: Container(
                                                  //     margin:
                                                  //         EdgeInsets.all(16),
                                                  //     // color: Colors.black54,
                                                  //     decoration: BoxDecoration(
                                                  //       color: Color(
                                                  //           0xFF96b2e1), // Background color
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //               10), // Rounded corners
                                                  //       boxShadow: [
                                                  //         BoxShadow(
                                                  //           color: Colors.black
                                                  //               .withOpacity(
                                                  //                   0.1), // Shadow color
                                                  //           blurRadius: 10,
                                                  //           spreadRadius: 2,
                                                  //           offset: Offset(0,
                                                  //               5), // Shadow position
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //     child: Container(
                                                  //       decoration:
                                                  //           BoxDecoration(
                                                  //         color: Color(
                                                  //             0xFF96b2e1), // Hex color #d5e6fa
                                                  //         borderRadius:
                                                  //             BorderRadius.circular(
                                                  //                 10), // Optional: Rounded corners
                                                  //       ),
                                                  //       margin:
                                                  //           EdgeInsets.all(5),
                                                  //       child: Row(
                                                  //         mainAxisAlignment:
                                                  //             MainAxisAlignment
                                                  //                 .end,
                                                  //         crossAxisAlignment:
                                                  //             CrossAxisAlignment
                                                  //                 .end,
                                                  //         children: [
                                                  //           Icon(
                                                  //             Icons
                                                  //                 .calendar_month,
                                                  //             size: 20,
                                                  //           ),
                                                  //           SizedBox(width: 5),
                                                  //           Text(
                                                  //             emergencyTitleList![
                                                  //                     index][
                                                  //                 'TaxNoOfYears'],
                                                  //             style: AppTextStyle
                                                  //                 .font14OpenSansRegularWhiteTextStyle,
                                                  //           )
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // Align items vertically
                                              children: <Widget>[
                                                CircleWithSpacing(),
                                                // Space between the circle and text
                                                Text(
                                                  'Premises Details :',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularGreenTextStyle,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  // color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Optional: Rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, left: 10),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Premises Name",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              emergencyTitleList![
                                                                      index][
                                                                  'sShopName'],
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              "Ward",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Center(
                                                            child: Text(
                                                              emergencyTitleList![
                                                                      index]
                                                                  ['sWardName'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  //color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Optional: Rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, left: 10),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Applicant Name",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              emergencyTitleList![
                                                                      index]
                                                                  ['sShopOwnreName'],
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              "Amount",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Center(
                                                            child: Text(
                                                              '₹ ${emergencyTitleList![index]['fTexAmuont'].toString()}',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end, // Aligns the container to the right
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width:
                                                        150, // Set the width of the container
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            16), // Optional padding
                                                    alignment: Alignment
                                                        .center, // Aligns text inside the container
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // Rounded corners
                                                    ),
                                                    child: Text(
                                                      "Make Payment",
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularWhiteTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        )),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ),

              // isLoading
              //     ? Center(child: Container())
              //     : (OnlineTitle == null || OnlineTitle!.isEmpty)
              //     ? NoDataScreenPage()
              //     :
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: <Widget>[
              //     // middleHeader(context, '${widget.name}'),
              //     Container(
              //       height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
              //       child: ListView.builder(
              //         shrinkWrap: true,
              //         // itemCount: emergencyTitleList?.length ?? 0,
              //         itemCount: OnlineTitle?.length ?? 0,
              //         itemBuilder: (context, index) {
              //           return Column(
              //             children: <Widget>[
              //               Padding(
              //                 padding: const EdgeInsets.only(left: 2,right: 2),
              //                 child: Container(
              //                   height: 60,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
              //                     color :Colors.white,
              //                     border: Border.all(
              //                       color: Colors.grey, // Border color
              //                       width: 1, // Border width
              //                     ),
              //                   ),
              //
              //                   child: Stack(
              //                     children: [
              //                       Container(
              //                           decoration: BoxDecoration(
              //                             borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
              //                             color :Color(0xFFF5F5F5),
              //                           ),
              //                           child: ListTile(
              //                             leading: Container(
              //                               // color: Colors.blueGrey,
              //                               width: 35,
              //                               height: 35,
              //                               // Height and width must be equal to make it circular
              //                               decoration: const BoxDecoration(
              //                                 // color: Colors.orange,
              //                                 shape: BoxShape.circle,
              //                               ),
              //                               child: Center(
              //                                 child: Image.asset(
              //                                   'assets/images/home12.jpeg',
              //                                   height: 25,
              //                                   width: 25,
              //                                   fit: BoxFit.cover,
              //                                 ),
              //                               ),
              //                             ),
              //                             title: Column(
              //                               mainAxisAlignment: MainAxisAlignment.start, // Centers items vertically
              //                               crossAxisAlignment: CrossAxisAlignment.start,
              //                               children: [
              //                                 Text('81(1)-1',style: TextStyle(
              //                                   color: Colors.black,
              //                                   fontSize: 14
              //                                 ),),
              //                                 SizedBox(height: 5),
              //                                 Text('House NO',style: TextStyle(
              //                                     color: Colors.black54,
              //                                     fontSize: 14
              //                                 ),),
              //                               ],
              //                             ),
              //                             trailing: Row(
              //                               mainAxisAlignment: MainAxisAlignment.start,
              //                               children: [
              //                                 Icon(Icons.calendar_month,size: 12),
              //                                 SizedBox(width: 5),
              //                                 Text("2019-1",style: TextStyle(),)
              //                               ],
              //                             )
              //                             // title: Text(
              //                             //      "81(1-1)",
              //                             //     //item['sWardName'] ?? '',
              //                             //     style: AppTextStyle
              //                             //         .font14penSansExtraboldBlack45TextStyle),
              //                           )),
              //                       Positioned(
              //                         top: 10,
              //                         right: 15,
              //                         child: GestureDetector(
              //                           onTap: (){
              //                             // print("------257-----");
              //                             //  sComplaintPhoto
              //                             // var image = "${item['sComplaintPhoto']}";
              //                             // print('------260----$image');
              //                             // // FullScreenImages
              //                             // Navigator.push(
              //                             //   context,
              //                             //   MaterialPageRoute(builder: (context) => FullScreenImages(image:image)),
              //                             // );
              //
              //                           },
              //                           child: Padding(
              //                             padding: const EdgeInsets.only(right: 70,left: 5),
              //                             child: Container(
              //                               width: 30,
              //                               height: 30,
              //                               // Height and width must be equal to make it circular
              //                               // decoration: const BoxDecoration(
              //                               //   color: Colors.white,
              //                               //   shape: BoxShape.circle,
              //                               //   // Makes the container circular
              //                               //   boxShadow: [
              //                               //     BoxShadow(
              //                               //       color: Colors.black26,
              //                               //       blurRadius: 5,
              //                               //       offset: Offset(0, 2),
              //                               //     ),
              //                               //   ],
              //                               // ),
              //                               child: Center(
              //           //                       child:  Row(
              //           // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between start and end
              //           // children: [
              //           // // Leading Icon (Circular)
              //           //   // Column with Two Text Widgets
              //           // SizedBox(width: 10), // Spacing between Icon and Column
              //           // Expanded(
              //           // child: Column(
              //           // crossAxisAlignment: CrossAxisAlignment.start,
              //           // children: [
              //           // Text(
              //           // 'Title Text',
              //           // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //           // ),
              //           // SizedBox(height: 5), // Space between two Texts
              //           // Text(
              //           // 'Subtitle Text',
              //           // style: TextStyle(fontSize: 14, color: Colors.grey),
              //           // ),
              //           // ],
              //           // ),
              //           // ),
              //           //
              //           // // Row at the End with Calendar Icon and Text
              //           // Row(
              //           // children: [
              //           // Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              //           // SizedBox(width: 5), // Space between Icon and Text
              //           // Text(
              //           // 'sii',
              //           // style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              //           // ),
              //           // ],
              //           // ),
              //           // ],
              //           // ),
              //                                 // child: Row(
              //                                 //   mainAxisAlignment: MainAxisAlignment.center,
              //                                 //  // crossAxisAlignment: CrossAxisAlignment.end,
              //                                 //   children: [
              //                                 //     Icon(Icons.calendar_month,
              //                                 //     size: 16,
              //                                 //     ),
              //                                 //     SizedBox(width: 4),
              //                                 //     Text("2018-19",style: TextStyle(
              //                                 //       color: Colors.black26,
              //                                 //       fontSize: 14
              //                                 //     ),)
              //                                 //   ],
              //                                 // ),
              //                                 // child: Image.asset(
              //                                 //   'assets/images/picture.png',
              //                                 //   height: 25,
              //                                 //   width: 25,
              //                                 //   fit: BoxFit.fill,
              //                                 // ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.symmetric(vertical: 1.0),
              //                 child: GestureDetector(
              //                   onTap: () {
              //                     // var name = emergencyTitleList![index]['sHeadName'];
              //                     // var iHeadCode = emergencyTitleList![index]['iHeadCode'];
              //                     // var sIcon = emergencyTitleList![index]['sIcon'];
              //
              //                     var title = OnlineTitle[index];
              //                     // sIcon
              //                     print('----title---207---$title');
              //                     if(title=="Property Tax"){
              //                       //  PropertyTax
              //                       var name = "Property Tax";
              //
              //                       Navigator.push(
              //                         context,
              //                         MaterialPageRoute(builder: (context) => PropertyTaxDiu(name:name)),
              //                       );
              //
              //                       //print('------209---Property Tax');
              //                     }else if(title=="Building Plan"){
              //                       print('------211---Building Plan');
              //                     }else if(title=="Property Assessment"){
              //                       print('------213---Property Assessment');
              //                     }else if(title=="License"){
              //                       print('------215---License');
              //                     }else if(title=="Community Hall"){
              //                       print('------217---Community Hall');
              //                     }else if(title=="Water Supply"){
              //                       print('------219---Water Supply');
              //                     }else if(title=="Electricity Bill"){
              //                       print("-------221--Electricity Bill--");
              //                       var sPageName = "Electricity Bill";
              //                       var sPageLink = "http://49.50.66.156/website/AboutCity.aspx";
              //
              //                       // Navigator.push(
              //                       //   context,
              //                       //   MaterialPageRoute(builder: (context) => AboutDiuPage(name:sPageName,sPageLink:sPageLink)),
              //                       // );
              //
              //                     }else if(title=="Mamlatdar Diu"){
              //                       print("-------223--Mamlatdar Diu--");
              //                       var sPageName = "Mamlatdar Diu";
              //                       var sPageLink = "http://49.50.66.156/website/AimsAndObjective.aspx";
              //                       // AboutDiuPage(name:sPageName,sPageLink:sPageLink);
              //
              //                       // Navigator.push(
              //                       //   context,
              //                       //   MaterialPageRoute(builder: (context) => AboutDiuPage(name:sPageName,sPageLink:sPageLink)),
              //                       // );
              //
              //                     }else{
              //                       print("-----225---");
              //                     }
              //
              //                     // Navigator.push(
              //                     //   context,
              //                     //   MaterialPageRoute(
              //                     //     builder: (context) =>
              //                     //         OnlineComplaintForm(name:name),
              //                     //   ),
              //                     // );
              //
              //                   },
              //                   child: ListTile(
              //                     leading: Container(
              //                       width: 35,
              //                       height: 35,
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(5),
              //                         gradient: const LinearGradient(
              //                           colors: [Colors.red, Colors.orange],
              //                           begin: Alignment.topLeft,
              //                           end: Alignment.bottomRight,
              //                         ),
              //                       ),
              //                       // child: Center(
              //                       //   child: Image.asset(
              //                       //     itemList2[index]['leadingIcon']!,
              //                       //     width: 30,
              //                       //     height: 30,
              //                       //     fit: BoxFit.cover,
              //                       //   ),
              //                       // ),
              //                     ),
              //                     title: Text(
              //                       //emergencyTitleList![index]['sHeadName']!,
              //                       // "Property Tax",
              //                       OnlineTitle[index],
              //                       style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
              //                     ),
              //                     trailing: Row(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         Image.asset(
              //                           'assets/images/arrow.png',
              //                           height: 12,
              //                           width: 12,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.only(left: 12, right: 12),
              //                 child: Container(
              //                   height: 1,
              //                   color: Colors.grey, // Gray color for the bottom line
              //                 ),
              //               ),
              //             ],
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }
}
