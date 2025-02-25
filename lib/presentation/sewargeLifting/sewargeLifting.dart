import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../app/loader_helper.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../../services/bindComplaintCategory.dart';
import '../../../services/cityzenpostcomplaintRepo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class SewargeLifting extends StatefulWidget {

  final complaintName;
  final categoryCode;
  final name;

  SewargeLifting({super.key, this.complaintName, this.categoryCode, this.name});

  @override
  State<SewargeLifting> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<SewargeLifting> {

  GeneralFunction generalFunction = GeneralFunction();
  final _formKey = GlobalKey<FormState>();

  File? image;
  String? todayDate;
  var result2,msg2;
  List distList = [];
  var _dropDownValueDistric;
  List stateList = [];
  List blockList = [];
  List marklocationList = [];    // bindComplaintSubCategory
  List bindComplaintSubCategory = [];
  List bindComplintWard = [];
  int selectedValue = -1;

  var _dropDownValueWard;
  var _dropDownValueComplaintSubCategory;
  var _selectedValueWard;
  var _selectedbindComplaintSubCategory;
  var _selectedBlockId;

  // Focus
  FocusNode namefieldfocus = FocusNode();
  final distDropdownFocus = GlobalKey();
  // controller
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController landmarkTextEditingController = TextEditingController();
  TextEditingController mentionTextEditingController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();
  // focus
  FocusNode categoryfocus = FocusNode();
  FocusNode addressfocus = FocusNode();
  FocusNode landMarkfocus = FocusNode();
  FocusNode mentionfocus = FocusNode();
  FocusNode namefocus = FocusNode();
  FocusNode mobilefocus = FocusNode();
  FocusNode fullAddressfocus = FocusNode();
  FocusNode remarksfocus = FocusNode();

  var uplodedImage;
  List<bool> isSelected = [false, false, false, false];
  final List<String> labels = ["Dry", "Wet", "Dry & Wet Both", "C & D Waste"];

  // get api BindComplaintApi

  marklocationData() async {
    bindComplaintSubCategory = await BindComplaintSubCategoryRepo().getbindcomplaintSub("${widget.categoryCode}");
    print(" -----xxxxx-  bindComplaintSubCategory--- Data--51---> $marklocationList");
    setState(() {});
  }
  // bindCityzenWard
  bindCityzenData() async {
    bindComplintWard = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  bindComplaintWard--- 62---> $bindComplintWard");
    setState(() {});
  }

  //
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://upegov.in/purionecitizenapi/api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;
      request.headers['sFolder'] = "CompImage";

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body);

      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      setState(() {
        uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      });
      print('----174--  xxxxx-$uplodedImage');
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  // PickImage
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----128---xxxxx----$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 20);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print(' Proof-------135----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    marklocationData();
    bindCityzenData();
    categoryfocus = FocusNode();
    addressfocus = FocusNode();
    landMarkfocus = FocusNode();
    mentionfocus = FocusNode();
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    categoryfocus.dispose();
    addressfocus.dispose();
    landMarkfocus.dispose();
    mentionfocus.dispose();
    landmarkController.dispose();
    remarksController.dispose();

    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus text fields when tapping outside
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,'${widget.name}'),
        // appBar: getAppBarBack(context,'JSSJSJ'),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15,bottom: 20,top: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.grey.withOpacity(0.5), // Color of the shadow
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15,bottom: 20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 0, right: 10, top: 10),
                                  child: Image.asset(
                                    'assets/images/garbage_vehicle.jpeg', // Replace with your image asset path
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Fill the below details',
                                      style: AppTextStyle
                                          .font16penSansExtraboldBlack45TextStyle),
                                ),
                              ],
                            ),
                            // name
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Name',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Container(
                                height: 42,
                                color: Color(0xFFf2f3f5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    focusNode: namefocus,
                                    controller: nameController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // labelText: AppStrings.txtMobile,
                                      // border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p10),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Enter location';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                            // mobile Number
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Mobile Number',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Container(
                                height: 42,
                                //  color: Colors.black12,
                                color: Color(0xFFf2f3f5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    focusNode: mobilefocus,
                                    controller: mobileNumberController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                        //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                      ],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // labelText: AppStrings.txtMobile,
                                      //  border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p10),
                                      //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Enter Description';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                            // fullAddress
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Full Address',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Container(
                                height: 42,
                                //  color: Colors.black12,
                                color: Color(0xFFf2f3f5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    focusNode: fullAddressfocus,
                                    controller: fullAddressController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // labelText: AppStrings.txtMobile,
                                      //  border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p10),
                                      //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Enter Description';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                            // LandMark
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Landmark',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Container(
                                height: 42,
                                //  color: Colors.black12,
                                color: Color(0xFFf2f3f5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    focusNode: landMarkfocus,
                                    controller: landmarkController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // labelText: AppStrings.txtMobile,
                                      //  border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p10),
                                      //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Enter Description';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                            // remarks
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Remarks',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Container(
                                height: 42,
                                //  color: Colors.black12,
                                color: Color(0xFFf2f3f5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    focusNode: remarksfocus,
                                    controller: remarksController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // labelText: AppStrings.txtMobile,
                                      //  border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p10),
                                      //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                                    ),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Enter Description';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                            // Request Details
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 0, right: 10, top: 10),
                                  child: Image.asset(
                                    'assets/images/garbage_vehicle.jpeg', // Replace with your image asset path
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Request Details',
                                      style: AppTextStyle
                                          .font16penSansExtraboldBlack45TextStyle),
                                ),
                              ],
                            ),
                            //price
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Prices',
                                      style: AppTextStyle
                                          .font14penSansExtraboldBlack45TextStyle),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(bottom: 5, top: 5),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: <Widget>[
                                         Container(
                                           width: 8,
                                           height: 8,
                                           decoration: const BoxDecoration(
                                               shape: BoxShape.circle,
                                               color: Colors.black54
                                           ),
                                         ),
                                         SizedBox(width: 5),
                                         Text('1500 Itr-Rs 700/-',
                                             style: AppTextStyle
                                                 .font14penSansExtraboldBlack45TextStyle),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               Spacer(),
                               Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black54
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text('3000 Itr-Rs 1000/-',
                                              style: AppTextStyle
                                                  .font14penSansExtraboldBlack45TextStyle),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // image Container
                            Container(
                             // height: 220,
                             //  decoration: BoxDecoration(
                             //    border: Border.all(color: Colors.grey, width: 2), // Gray outline
                             //    borderRadius: BorderRadius.circular(10), // Rounded corners
                             //  ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5, top: 5,left: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text('Uplode Photo',
                                            style: AppTextStyle
                                                .font14penSansExtraboldBlack45TextStyle),
                                      ],
                                    ),
                                  ),
                                  // Container
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 1), // Gray outline
                                        borderRadius: BorderRadius.circular(10), // Rounded corners
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Click Photo",style: AppTextStyle
                                                        .font12penSansExtraboldBlack45TextStyle
                                                    ),
                                                    Text("Please click a photo",style: AppTextStyle
                                                        .font12penSansExtraboldRedTextStyle
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: (){
                                                    print("-----791----");
                                                    pickImage();
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[300], // Light gray background
                                                            borderRadius: BorderRadius.circular(25), // Rounded corners
                                                          ),
                                                          child: Center(
                                                            child: Image.asset(
                                                              'assets/images/ic_camera.PNG', // Replace with your asset image path
                                                              height: 40,
                                                              width: 40,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        image != null
                                            ? Stack(
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             FullScreenPage(
                                                //               child: image!,
                                                //               dark: true,
                                                //             )));
                                              },
                                              child: Container(
                                                  color: Colors.lightGreenAccent,
                                                  height: 100,
                                                  width: 70,
                                                  child: Image.file(
                                                    image!,
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),
                                            Positioned(
                                                bottom: 65,
                                                left: 35,
                                                child: IconButton(
                                                  onPressed: () {
                                                    image = null;
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                ))
                                          ],
                                        )
                                            : Text("",
                                            style: AppTextStyle
                                                .font14penSansExtraboldRedTextStyle),
                                      ]),
                                  // sumbit button

                                ],
                              ),
                            ),
                            // sumit Button
                            Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var random = Random();
                                    // Generate an 8-digit random number
                                    int randomNumber = random.nextInt(99999999 - 10000000) + 10000000;
                                    print('Random 8-digit number---770--: $randomNumber');

                                    var name = nameController.text.trim();
                                    var mobileNumber = mobileNumberController.text.trim();
                                    var fullAddress = fullAddressController.text.trim();
                                    var landmark = landmarkController.text.trim();
                                    var remark = remarksController.text.trim();


                                    print('---name--$name');
                                    print('---mobileNumber--$mobileNumber');
                                    print('---fullAddress--$fullAddress');
                                    print('--landmark--$landmark');
                                    print('--remark-----$remark');// uplodedImage

                                    if (_formKey.currentState!.validate() &&
                                        name.isNotEmpty &&
                                        mobileNumber.isNotEmpty &&
                                        fullAddress.isNotEmpty &&
                                        landmark.isNotEmpty &&
                                        remark.isNotEmpty &&
                                        uplodedImage !=null || uplodedImage !=''
                                    ) {
                                      print("---call Api---");

                                      /// TODO CALL API HERE

                                      // var markPointSubmitResponse =
                                      // await MarkPointSubmitRepo().markpointsubmit(
                                      //     context,
                                      //     randomNumber,
                                      //     address,
                                      //     landmark,
                                      //     mention,
                                      //     _dropDownValueComplaintSubCategory,
                                      //     _dropDownValueWard,
                                      //     uplodedImage
                                      // );
                                      //
                                      // print('----805---$markPointSubmitResponse');
                                      // result2 = markPointSubmitResponse['Result'];
                                      // print('---result---xxx---$result2');
                                      // msg2 = markPointSubmitResponse['Msg'];

                                    } else {
                                      print('---call Api not call---');
                                      if(name.isEmpty){
                                        displayToast('Please enter Name');
                                        return;
                                      }else if(mobileNumber.isEmpty){
                                        displayToast('Please enter Mobile Number');
                                        return;
                                      }else if(fullAddress.isEmpty){
                                        displayToast('Please enter Full Address');
                                        return;
                                      }else if(landmark.isEmpty){
                                        displayToast('Please enter Landmark');
                                        return;
                                      }else if(remark.isEmpty){
                                        displayToast('Please enter Remarks');
                                        return;
                                      }else if(uplodedImage==null || uplodedImage ==''){
                                        displayToast('Pick a Image');
                                        return;
                                      }else{

                                      }
                                    }
                                    if(result2=="1"){
                                      print('------823----xxxxxxxxxxxxxxx----');
                                      print('------823---result2  -xxxxxxxxxxxxxxx--$result2');
                                      displayToast(msg2);
                                      Navigator.pop(context);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => const HomePage()),
                                      // );
                                    }else{

                                      displayToast(msg2);
                                    }
                                    /// Todo next Apply condition
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                                  ),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  )
                              ),
                            )




                      ])

                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
