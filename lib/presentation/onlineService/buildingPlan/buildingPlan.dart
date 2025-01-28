
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../app/generalFunction.dart';
import '../../../services/getEmergencyContactTitleRepo.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';
import 'buildingPlanApplication.dart';
import 'buildingPlanStatus.dart';
import 'occupationCertificate.dart';



class BuildingPlan extends StatefulWidget {

  final name;
  BuildingPlan({super.key, this.name});

  @override
  State<BuildingPlan> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<BuildingPlan> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String,dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await GetEmergencyContactTitleRepo().getEmergencyContactTitle(context);
    print('------34----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }

  var OnlineTitle = [
    "Building Plan Application",
    "Building Plan Status",
    "Occupation Certificate",
  ];
  // "Water Supply",
  // "Electricity Bill",
  // "Mamlatdar Diu"

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

  @override
  void initState() {
    // TODO: implement initState
    getEmergencyTitleResponse();
    super.initState();
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF12375e),
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        centerTitle: true,
        backgroundColor: Color(0xFF255898),
        leading: GestureDetector(
          onTap: (){
            print("------back---");
             Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
            // );
          },
          child: Icon(Icons.arrow_back_ios,
            color: Colors.white,),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '${widget.name}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        //centerTitle: true,
        elevation: 0, // Removes shadow under the AppBar
      ),
      //appBar: getAppBarBack(context, '${widget.name}'),

      drawer:
      generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

      body:
      isLoading
          ? Center(child: Container())
          : (OnlineTitle == null || OnlineTitle!.isEmpty)
          ? NoDataScreenPage()
          :
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // middleHeader(context, '${widget.name}'),
          Container(
            height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
            child: ListView.builder(
              shrinkWrap: true,
              // itemCount: emergencyTitleList?.length ?? 0,
              itemCount: OnlineTitle?.length ?? 0,
              itemBuilder: (context, index) {
              final color = borderColors[index % borderColors.length];
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: GestureDetector(
                        onTap: () {
                          var title = OnlineTitle[index];
                          // sIcon
                          print('----title---207---$title');
                          if(title=="Building Plan Application"){
                            //  PropertyTax
                            var name = "Building Plan Application";
                            var iCategoryCode ="3";

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuildingPlanApplication(name:name,iCategoryCode:iCategoryCode)),
                            );
                          }else if(title=="Building Plan Status"){
                            var name = "Building Plan Status";
                            var iCategoryCode ="3";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuildingPlanStatus(name:name,iCategoryCode:iCategoryCode)),
                            );
                            print('------211---Building Plan');
                            // BuildingPlanStatus
                          }else {
                            var name = "Occupation Certificate";
                            var iCategoryCode ="3";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OccupationCertificate(name:name,iCategoryCode:iCategoryCode)),
                            );
                            print('------211---Building Plan');
                          }
                        },
                        child: ListTile(
                          leading: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: color, // Set the dynamic color
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.ac_unit,
                                color: Colors.white,
                              )
                          ),
                          title: Text(
                            OnlineTitle[index],
                            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/arrow.png',
                                height: 12,
                                width: 12,
                                color: color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey, // Gray color for the bottom line
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

