import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puri/services/GetMutationStatusRepo.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/BindLicenseStatusRepo.dart';
import '../../circle/circle.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';


class PropertyMutationStatus extends StatefulWidget {
  final name;
  PropertyMutationStatus({super.key, this.name});

  @override
  State<PropertyMutationStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<PropertyMutationStatus> {

  GeneralFunction generalFunction = GeneralFunction();

  var variableName;
  var variableName2;
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>>? getMutationStatus;
  List<Map<String, dynamic>> _filteredData = [];
  List bindAjencyList = [];
  List userAjencyList = [];
  var iAgencyCode;
  var agencyUserId;
  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  var _dropDownAgency2;
  var _dropDownValueUserAgency;
  final distDropdownFocus = GlobalKey();
  var result, msg;
  var userAjencyData;
  var result1;
  var msg1;
  GeneralFunction generalfunction = GeneralFunction();
  bool isLoading = true;

  // Api response

  // pendingInternalComplaintResponse() async {
  //   //  PropertyMutationStatusRepo ---propertyMutationStatus
  //   pendingInternalComplaintList = await BindLicenseStatusRepo().bindLicenseStatus(context);
  //   print('-----55--->>>>>>----$pendingInternalComplaintList');
  //   _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);
  //
  //   setState(() {
  //     // parkList=[];
  //     isLoading = false;
  //   });
  // }
  pendingInternalComplaintResponse() async {
    //  PropertyMutationStatusRepo ---propertyMutationStatus
    getMutationStatus = await GetMutationStatusRepo().getMutationStatus(context);
    print('-----55--->>>>>>----$getMutationStatus');
    _filteredData = List<Map<String, dynamic>>.from(getMutationStatus ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    pendingInternalComplaintResponse();
    _searchController.addListener(_search);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = getMutationStatus?.where((item) {
        String location = item['sApplicantName'].toLowerCase();
        String pointType = item['sFathersName'].toLowerCase();
        String sector = item['sApplicantMobile'].toLowerCase();
        return location.contains(query) ||
            pointType.contains(query) ||
            sector.contains(query);
      }).toList() ??
          [];
    });
  }

  // location
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    setState(() {

    });
  }

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
      onTap: (){
        FocusScope.of(context).unfocus(); // Unfocus any focused widget
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,'${widget.name}'),
        // appBar: getAppBarBack(context,'jjsjsjsj'),
        drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body :
        // pendingInternalComplaintList == null
        //   ? NoDataScreen()
        //   :
        isLoading
            ? Center(child:
        Container())
            : (getMutationStatus == null || getMutationStatus!.isEmpty)
            ? NoDataScreenPage()
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey, // Outline border color
                      width: 0.2, // Outline border width
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Enter Keywords',
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF707d83),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // scroll item after search bar
            Expanded(
              child: ListView.builder(
                itemCount: _filteredData.length ?? 0,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _filteredData[index];
                  var pending = item['sStatusName'];

                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: Container(
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shadowColor: Colors.white,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2,right: 2),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                        color :Colors.white,
                                        border: Border.all(
                                          color: Colors.grey, // Border color
                                          width: 1, // Border width
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                                color :Color(0xFFF5F5F5),
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  // color: Colors.blueGrey,
                                                  width: 35,
                                                  height: 35,
                                                  // Height and width must be equal to make it circular
                                                  decoration: const BoxDecoration(
                                                    // color: Colors.orange,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/images/home12.jpeg',
                                                      height: 25,
                                                      width: 25,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                // title: Text(item['sWardName'] ?? '',
                                                //     style: AppTextStyle
                                                //         .font14penSansExtraboldBlack45TextStyle),
                                              )),

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Mutation Type',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sMutationType'].toString() ?? '',
                                        style: AppTextStyle
                                            .font14OpenSansRegularRedTextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Mutation Fee',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['fMutationFee'].toString() ?? "0",
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Applicant Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sApplicantName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  // Applicant Father Name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Applicant Father Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sFathersName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  //Applicant  Mobile number
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              CircleWithSpacing(),
                                              Text('Applicant Mobile Number',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sApplicantMobile'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      pending !="Pending" ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              gradient: const LinearGradient(
                                                // colors: [Colors.red, Colors.orange],
                                                colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),

                                            ),
                                            child:Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Center(
                                                child: Text(
                                                    "Make Payment",
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularWhiteTextStyle),
                                              ),
                                            ),
                                          ),


                                          // Container(
                                          //   height: 45,
                                          //   color: Colors.blue,
                                          //   child: Text("Make Payment"),
                                          // )
                                        ],
                                      )
                                          :SizedBox()],
                                  ),
                                  // Owner name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              CircleWithSpacing(),
                                              Text('Owner Name',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sCurOwner'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                      // Spacer(),
                                      // pending !="Pending" ?
                                      // Column(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   crossAxisAlignment: CrossAxisAlignment.end,
                                      //   children: [
                                      //     Container(
                                      //       height: 35,
                                      //       decoration: BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(5),
                                      //         gradient: const LinearGradient(
                                      //           // colors: [Colors.red, Colors.orange],
                                      //           colors: [Color(0xFF255898),Color(0xFF12375e)],
                                      //           begin: Alignment.topLeft,
                                      //           end: Alignment.bottomRight,
                                      //         ),
                                      //
                                      //       ),
                                      //       child:Padding(
                                      //         padding: const EdgeInsets.only(left: 10,right: 10),
                                      //         child: Center(
                                      //           child: Text(
                                      //               "Make Payment",
                                      //               style: AppTextStyle
                                      //                   .font14OpenSansRegularWhiteTextStyle),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //
                                      //
                                      //     // Container(
                                      //     //   height: 45,
                                      //     //   color: Colors.blue,
                                      //     //   child: Text("Make Payment"),
                                      //     // )
                                      //   ],
                                      // )
                                      //     :SizedBox()
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Address',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sApplicationAddr'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Status',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sStatusName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  pending !="Pending" ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5,left: 5,right: 5,top: 5),
                                        child: Row(
                                          children: [
                                            // First Container
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                //color: Colors.blue,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: const LinearGradient(
                                                    // colors: [Colors.red, Colors.orange],
                                                    colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),

                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, top: 5),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Action By",
                                                          style: AppTextStyle
                                                              .font140penSansExtraboldWhiteTextStyle),
                                                      Text(item['dActionBy'] ?? 'No Action by',
                                                          style: AppTextStyle
                                                              .font140penSansExtraboldWhiteTextStyle)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            // Second Container
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 0),
                                                child: Container(
                                                  height: 50,
                                                  //color: Colors.blue,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    gradient: const LinearGradient(
                                                      colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Action At',
                                                            style: AppTextStyle
                                                                .font140penSansExtraboldWhiteTextStyle),
                                                        Text(item['dActionRemarks'] ?? 'No Action At',
                                                            style: AppTextStyle
                                                                .font140penSansExtraboldWhiteTextStyle)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        // color: Colors.blue,
                                        color: Color(0x4D565DFF),
                                        // 4D565DFF
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(width: 5),
                                            Container(
                                              height: 40,
                                              width: 4,
                                              color: Colors.red,

                                            ),
                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Remarks',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                  SizedBox(height: 5),
                                                  Text(item['dActionRemarks'] ?? 'No Remarks',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularRedTextStyle),
                                                ],
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),

      ),
    );
  }

}
class NoDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Record Found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
