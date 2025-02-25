
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../aboutDiu/aboutdiu.dart';
import '../birth_death/birthanddeath.dart';
import '../bookAdvertisement/bookAdvertisement.dart';
import '../emergencyContact/emergencyContact.dart';
import '../garbageRequest/garbaseRequest.dart';
import '../helpline_feedback/helplinefeedback.dart';
import '../knowyourward/KnowYourWard.dart';
import '../onlineComplaint/onlineComplaint.dart';
import '../onlineService/onlineService.dart';
import '../resources/app_text_style.dart';
import '../sewargeLifting/sewargeLifting.dart';
import '../toilet_locator/utilityLocator.dart';
import 'grievanceStatus/grievanceStatus.dart';

class ComplaintHomePage extends StatefulWidget {

  const ComplaintHomePage({super.key});

  @override
  State<ComplaintHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintHomePage> {

  GeneralFunction generalFunction = GeneralFunction();
  //  drawerFunction
  String? sCitizenName;
  String? sContactNo;
  String? sContactNo2;
  String? sContactNo3;

  @override
  void initState() {
    // TODO: implement initState
    getLocatdata();
    super.initState();
  }
  getLocatdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCitizenName = prefs.getString('sCitizenName');
    sContactNo = prefs.getString('sContactNo');
    print('---46--$sCitizenName');
    print('---47--$sContactNo');
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  Widget logoutDialogBox(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      title: Text('Do you want to log out?'),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Background color
          ),
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Background color
          ),
          child: Text('Yes'),
          onPressed: () {
            // Add your logout functionality here
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar
       appBar: appBarFunction(context,"Puri One"),
        drawer: generalFunction.drawerFunction_2(context,"$sCitizenName","$sContactNo"),
        body: Stack(
         // fit: StackFit.expand, // Make the stack fill the entire screen
          children: [
            /// todo here you applh border Image
            Container(
              height: 210, // Set the height of the container
              width: double.infinity, // Optionally set width to full screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/temple_3.png"), // Path to your image
                  fit: BoxFit.fill, // Adjust the image to fill the container
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(
                      top: 200,
                      left: 0,
                      right: 0,
                      bottom: 5),
              child:Container(
                 // width: 300, // Set the width of the container
                  height: MediaQuery.of(context).size.height, // Set the height of the container
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/background.png'), // Your asset path
                      fit: BoxFit.cover, // Adjust how the image fits the container
                    ),
                    borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.watch_later_rounded),
                            SizedBox(width: 15),
                            Text("Funtional Activites",style: AppTextStyle.font16penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                        SizedBox(height: 10),
                        // top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the columns
                          children: [
                            // Column 1
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  OnlineComplaint(name: "Raise Grievance")),
                                  );
                                  print("------Raise Grievance----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/online_Complain.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                       Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                        'Raise Grievance',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GrievanceStatus(name: "Grievance Status")),
                                  );
                                  print("------Grievance Status----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/complaint_list.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Grievance Statu',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var name = "Garbage Request";
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  GarbaseRequest(name:name)),
                                  );
                                  print("------Garbage Reque----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/complaint_list.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Garbage Reque',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the columns
                          children: [
                            // Column 1
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SewargeLifting(name: "Sewerage Lifting")),
                                  );
                                  print("------Sewerge Lifting----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/vehicle_locater.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Sewerge Lifting',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var name = "Tax Payment";
                                  var webUrl ="https://sujogportal.odisha.gov.in/puri/service/property-tax/";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BirthAndDeathCertificate(name:name,webUrl:webUrl),
                                      ));
                                  print("------Tax Payment----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/tax_payment.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Tax Payment',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var pageName = "Know Your Ward";
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            KnowYourWard(pageName:pageName)),
                                  );
                                  print("------Know Your Ward----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/know_ward.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Know Your War',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the columns
                          children: [
                            // Column 1
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var name = "Marriage Certificate";
                                  var webUrl ="https://sujog.odisha.gov.in/home";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BirthAndDeathCertificate(name:name,webUrl:webUrl),
                                      ));
                                  print("------Marriage Certificate----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/marriage_certificate.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Marriage Certifi',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var name="Birth & Death Cert";
                                  var webUrl ="https://www.birthdeath.odisha.gov.in/#/home";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BirthAndDeathCertificate(name:name,webUrl:webUrl),
                                      ));
                                  print("------Birth and Death----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/birth_certificate.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Birth & Death C',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  UtilityLocator()),
                                  );
                                  print("------Public Utilities----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/property_mutation.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Public Utilities',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers the columns
                          children: [
                            // Column 1
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmergencyContacts(name: "Emergency Contacts")),
                                  );
                                  print("------Emergency Calll----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_9.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        // decoration: BoxDecoration(
                                        //   borderRadius: BorderRadius.circular(25),
                                        //   // half of width and height for a circle
                                        //   //color: Colors.green
                                        //   color: Color(0xFFD3D3D3),
                                        // ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/emergencyContact.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Emergency Con',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HelpLineFeedBack(
                                          name: "Marriage Certificate", image: '',)),
                                  );
                                  print("------Help line Feedback----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_8.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/helpline_feedback.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'Helpline Feedb',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  var name = "About Puri";
                                  var webUrl ="https://upegov.in/Puriswm/News/PURIATAGLANCE.html";
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BirthAndDeathCertificate(name:name,webUrl:webUrl),
                                      ));
                                  print("------About Puri----");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2, // Border thickness
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10), // Creates a gap between content and border
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                            fit: BoxFit.cover, // Adjust how the image fits within the container
                                          ),
                                          borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                        ),
                                        child: const Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/about_diu.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: Colors.black, thickness: 1), // Divider
                                      //SizedBox(height: 10),
                                      Text(
                                          'About Puri',
                                          style: AppTextStyle.font14penSansExtraboldGreenTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //-----first row


                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(builder: (context) =>  OnlineComplaint(name: "Raise Grievance")),
                        //         );
                        //         },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                       image: AssetImage(
                        //                           'assets/images/online_Complain.png'),
                        //                       width: 45,
                        //                       height: 45,
                        //                     )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                  Container(
                        //                    height: 1,
                        //                    color: Colors.black12,
                        //                  ),
                        //                   SizedBox(height: 5),
                        //                   // complaint_status
                        //                   Text('Raise Grievance',
                        //                     style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   GrievanceStatus(name: "Grievance Status")),
                        //         );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side: const BorderSide(
                        //                   color: Colors.orange, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                       image: AssetImage(
                        //                           'assets/images/complaint_list.png'),
                        //                       width: 45,
                        //                       height: 45,
                        //                     )),
                        //                   ),
                        //                   // complaint_status.png
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Grievance Status',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldOrangeTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10),
                        // // second Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //         print("----327--Garbage--");
                        //         var name = "Garbage Request";
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(builder: (context) =>  GarbaseRequest(name:name)),
                        //         );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/book_advertisement.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   // complaint_status
                        //                   Text('Garbage Request',
                        //                     style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         // Add your onTap functionality here
                        //         print('-----109------');
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //       builder: (context) =>
                        //         //           PendingComplaintScreen()),
                        //         // );
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   SewargeLifting(name: "Sewerage Lifting")),
                        //         );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side: const BorderSide(
                        //                   color: Colors.orange, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/vehicle_locater.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   // complaint_status.png
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Sewerage Lifting',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldOrangeTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10),
                        // // Third Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //         print("----500--Tax Payment");
                        //         // call a web page
                        //         var name = "Tax Payment";
                        //         var webUrl ="https://sujogportal.odisha.gov.in/puri/service/property-tax/";
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   BirthAndDeathCertificate(name:name,webUrl:webUrl),
                        //             ));
                        //
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(builder: (context) =>  OnlineComplaint(name: "Online Complaint")),
                        //         // );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/tax_payment.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   // complaint_status
                        //                   Text('Tax Payment',
                        //                     style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         var pageName = "Know Your Ward";
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   KnowYourWard(pageName:pageName)),
                        //         );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side: const BorderSide(
                        //                   color: Colors.orange, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/know_ward.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   // complaint_status.png
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Know Your Ward',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldOrangeTextStyle,
                        //                     // style: GoogleFonts.lato(
                        //                     //     textStyle: Theme.of(context).textTheme.titleSmall,
                        //                     //     fontSize: 14,
                        //                     //     fontWeight: FontWeight.w700,
                        //                     //     fontStyle: FontStyle.italic,
                        //                     //     color:Colors.orange
                        //                     // ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // // -- Fourth Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //
                        //         // marrige Certificate Url.
                        //         var name = "Marriage Certificate";
                        //         var webUrl ="https://sujog.odisha.gov.in/home";
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   BirthAndDeathCertificate(name:name,webUrl:webUrl),
                        //             ));
                        //         },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/marriage_certificate.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   // complaint_status
                        //                   Text('Marriage Certificate',
                        //                     style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         print('-----52------');
                        //         var name="Birth & Death Cert";
                        //         var webUrl ="https://www.birthdeath.odisha.gov.in/#/home";
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   BirthAndDeathCertificate(name:name,webUrl:webUrl),
                        //             ));
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side:
                        //               BorderSide(color: Colors.orange, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/birth_certificate.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Birth & Death Cert',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldOrangeTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // // Fifth Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(builder: (context) =>  UtilityLocator()),
                        //         );
                        //         },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/property_mutation.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   // complaint_status
                        //                   Text('Public Utilities',
                        //                     style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         // displayToast("Coming Soon");
                        //         // BookAdvertisement
                        //         // Add your onTap functionality here
                        //         print('-----177------');
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => EmergencyContacts(name: "Emergency Contacts")),
                        //         );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(
                        //                   color: Colors.orange,
                        //                   width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_9.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     // decoration: BoxDecoration(
                        //                     //   borderRadius: BorderRadius.circular(25),
                        //                     //   // half of width and height for a circle
                        //                     //   //color: Colors.green
                        //                     //   color: Color(0xFFD3D3D3),
                        //                     // ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                           image: AssetImage(
                        //                               'assets/images/emergencyContact.png'),
                        //                           width: 45,
                        //                           height: 45,
                        //                         )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Emergency Contacts',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // // Six Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => HelpLineFeedBack(
                        //                   name: "Marriage Certificate", image: '',)),
                        //         );
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //       builder: (context) => MarriageCertificate(
                        //         //           name: "Marriage Certificate")),
                        //         // );
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             left: BorderSide(
                        //               color: Colors.green,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomLeft: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             margin: EdgeInsets.all(5.0),
                        //             shadowColor: Colors.green,
                        //             shape: RoundedRectangleBorder(
                        //               side:
                        //                   BorderSide(color: Colors.green, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_8.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                       image: AssetImage(
                        //                           'assets/images/helpline_feedback.png'),
                        //                       width: 45,
                        //                       height: 45,
                        //                     )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'Helpline/Feedback',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldOrangeTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //     SizedBox(width: 5),
                        //     InkWell(
                        //       onTap: () {
                        //         // Add your onTap functionality here
                        //         //print('-----353------');
                        //
                        //         //----Open a url about a puri
                        //         var name = "About Puri";
                        //         var webUrl ="https://upegov.in/Puriswm/News/PURIATAGLANCE.html";
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   BirthAndDeathCertificate(name:name,webUrl:webUrl),
                        //             ));
                        //
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //       builder: (context) => AboutDiu(
                        //         //           name: "About Puri")),
                        //         // );
                        //
                        //       },
                        //       child: Container(
                        //         height: 120,
                        //         width: MediaQuery.of(context).size.width / 2 - 14,
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             right: BorderSide(
                        //               color: Colors.orange,
                        //               // Specify your desired border color here
                        //               width: 5.0, // Adjust the width of the border
                        //             ),
                        //           ),
                        //           borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(10.0),
                        //             // Adjust the radius for the top-left corner
                        //             bottomRight: Radius.circular(
                        //                 10.0), // Adjust the radius for the bottom-left corner
                        //           ),
                        //         ),
                        //         // color: Colors.black,
                        //         child: Card(
                        //             elevation: 10,
                        //             shadowColor: Colors.orange,
                        //             shape: RoundedRectangleBorder(
                        //               side: BorderSide(
                        //                   color: Colors.orange, width: 0.5),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(top: 10),
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     width: 60,
                        //                     height: 60,
                        //                     decoration: BoxDecoration(
                        //                       image: const DecorationImage(
                        //                         image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                        //                         fit: BoxFit.cover, // Adjust how the image fits within the container
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                        //                     ),
                        //                     child: const Center(
                        //                         child: Image(
                        //                       image: AssetImage(
                        //                           'assets/images/about_diu.png'),
                        //                       width: 45,
                        //                       height: 45,
                        //                     )),
                        //                   ),
                        //                   SizedBox(height: 10),
                        //                   Container(
                        //                     height: 1,
                        //                     color: Colors.black12,
                        //                   ),
                        //                   SizedBox(height: 5),
                        //                   Text(
                        //                     'About Puri',
                        //                     style: AppTextStyle
                        //                         .font14penSansExtraboldGreenTextStyle,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
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
