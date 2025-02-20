import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
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
import '../../services/PostCitizenRequestMobileRepo.dart';
import '../../services/baseurl.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class GarbaseRequest extends StatefulWidget {

  final complaintName;
  final categoryCode;
  final name;

  GarbaseRequest({super.key, this.complaintName, this.categoryCode, this.name});

  @override
  State<GarbaseRequest> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<GarbaseRequest> {

  GeneralFunction generalFunction = GeneralFunction();

  final _formKey = GlobalKey<FormState>();
  File? image;
  String? todayDate;
  var result2,msg2;
  List distList = [];
  var _dropDownValueDistric;
  List stateList = [];
  List blockList = [];
  List marklocationList = [];// bindComplaintSubCategory
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
  var selectedNameWasteType;
  var sContactNo;
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
  // focus
  FocusNode categoryfocus = FocusNode();
  FocusNode addressfocus = FocusNode();
  FocusNode landMarkfocus = FocusNode();
  FocusNode mentionfocus = FocusNode();
  FocusNode namefocus = FocusNode();

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
    print(" -----xxxxx-  bindComplaintWard--- 87---> $bindComplintWard");
    setState(() {});
  }

  //
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
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

    lat = position.latitude;
    long = position.longitude;
    print('-----------139----$lat');
    print('-----------140----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }
  // generateRandomNumber
  String generateRandom20DigitNumber() {
    final Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return randomNumber;
  }

  Future<void> uploadImage(String token, File imageFile) async {
    print("--------225---tolen---$token");
    print("--------226---imageFile---$imageFile");
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostImage/PostImage";
    var uploadImageApi = "$baseURL$endPoint";
    try {
      print('-----xx-x----214----');
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST', Uri.parse('$uploadImageApi'),
      );
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath('sFolder',imageFile.path,
      ));
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      print("---------248-----$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        uplodedImage = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----194--: $uplodedImage');
      } else {
        print('Unexpected response format: $responseData');
      }
      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  // bindi ward
  Widget _bindWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: TextSpan(
                  text: "Select Garbage Request Type",
                  style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: AppTextStyle
                            .font14penSansExtraboldBlack45TextStyle),
                  ],
                ),
              ), // Not necessary for Option 1
              value: _dropDownValueWard,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueWard = newValue;
                  print('---33-------$_dropDownValueWard');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  bindComplintWard.forEach((element) {
                    if (element["sWasteType"] == _dropDownValueWard) {
                      setState(() {
                        _selectedValueWard = element['sWasteCode'];
                        print('----Selectred Ward---198--------$_selectedValueWard');
                      });
                      print('-----Point id----241---$_selectedValueWard');
                      if (_selectedValueWard != null) {
                        // updatedBlock();
                        print('-----Point id----244---$_selectedValueWard');
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
              items: bindComplintWard.map((dynamic item) {
                return DropdownMenuItem(
                  value: item["sWasteCode"].toString(),
                  child: Container(
                    width: 280, // Set an appropriate width based on your UI
                    child: Text(
                      item['sWasteType'].toString(),
                      maxLines: 2, // Allows up to 2 lines
                      overflow: TextOverflow.ellipsis, // Shows "..." if text is too long
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

  @override
  void initState() {
    // TODO: implement initState
    marklocationData();
    bindCityzenData();
    getLocation();
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
      //  appBar: getAppBarBack(context,'JSSJSJ'),
       // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

        body: ListView(
          children: <Widget>[
           // middleHeader(context, '${widget.complaintName}'),
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
                            // Address
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
                                  Text('Address', style: AppTextStyle.font14penSansExtraboldBlack45TextStyle),
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
                                    focusNode: addressfocus,
                                    controller: addressTextEditingController,
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
                            // Landmark
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
                                    focusNode: mentionfocus,
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
                            SizedBox(height: 10),
                            // uplode Request
                            Container(
                              height: 480,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 2), // Gray outline
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // Upload Request Type
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
                                        Text('Upload Request',
                                            style: AppTextStyle
                                                .font14penSansExtraboldBlack45TextStyle),
                                      ],
                                    ),
                                  ),
                                  // DropDown code Garbase Request Type
                                  _bindWard(),
                                  SizedBox(height: 10),
                                  // waste Type
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
                                        Text('Waste Type',
                                            style: AppTextStyle
                                                .font14penSansExtraboldBlack45TextStyle),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space between items
                                      children: List.generate(4, (index) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Label Text
                                            Radio<int>(
                                              value: index,
                                              groupValue: selectedValue, // Ensures only one selection
                                              onChanged: (int? value) {
                                                setState(() {
                                                  selectedValue = value!;
                                                });
                                                selectedNameWasteType = labels[index];
                                                print("---727----$selectedNameWasteType");
                                              },
                                            ),
                                            Text(labels[index]),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // Upload Photo
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
                                                   Text("Please click a garbage photo",style: AppTextStyle
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
                                            style: AppTextStyle.font14penSansExtraboldRedTextStyle),
                                      ]),
                                  // sumbit button
                                  SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          //
                                          var random = Random();
                                          // Generate an 8-digit random number
                                          int randomNumber = random.nextInt(99999999 - 10000000) + 10000000;
                                          print('Random 8-digit number---770--: $randomNumber');

                                          var address = addressTextEditingController.text.trim();
                                          var landmark = landmarkController.text.trim();
                                          var remarks = remarksController.text.trim();

                                          print("-----address--$address");
                                          print("-----landmark--$landmark"); // sMohalla
                                          print("-----remarks--$remarks");   // sUserRemarks
                                          print("----Waste type ---$selectedNameWasteType"); // iWasteType
                                          print("-----SelectedWardCode---$_dropDownValueWard"); //  sRequestTypeCode
                                          print("---images ----$uplodedImage"); // sImage_1
                                          //  sWardCode
                                          print("---lat -----$lat");
                                          print("---long -----$long");
                                          print("-----sContactNo---$sContactNo");

                                          if (_formKey.currentState!.validate() &&
                                              address !=null &&
                                              landmark !=null &&
                                              remarks != null &&
                                              _dropDownValueWard !=null &&
                                              selectedNameWasteType !=null
                                          ) {
                                            print('---Api call----');
                                            // Her you should change api
                                            var markPointSubmitResponse =
                                            await PostCitizenRequestMobileRepo().postCitizenRequest(
                                                context,
                                                address,
                                                landmark,
                                                remarks,
                                                selectedNameWasteType,
                                                _dropDownValueWard,
                                                uplodedImage,
                                                lat,
                                                long
                                            );

                                            print('----810---$markPointSubmitResponse');
                                            result2 = markPointSubmitResponse['Result'];
                                            print('---result---xxx---$result2');
                                            msg2 = markPointSubmitResponse['Msg'];

                                          } else {
                                            print('---call Api not call---');
                                            if(address.isEmpty){
                                              displayToast('Please enter Address');
                                              return;
                                            }else if(landmark.isEmpty){
                                              displayToast('Please enter Landmark');
                                              return;
                                            }else if(remarks.isEmpty){
                                              displayToast('Please enter Remarks');
                                              return;
                                            }else if(_dropDownValueWard==null){
                                              displayToast('Please Select Garbage Request Type');
                                              return;
                                            }else if(selectedNameWasteType==null){
                                              displayToast('Please Select Waste Type');
                                              return;
                                            }else if(uplodedImage==null || uplodedImage==""){
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
                                          backgroundColor: Color(0xFF255899), // Hex color code (FF for alpha, followed by RGB)
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

                                ],
                              ),
                            ),
                          ]
                      )

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
