import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/CitizenRequestDetailsSewerageRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../resources/app_text_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/CitizenRequestDetailsRepo.dart';
import '../../services/GetNearByPlacesTypeRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../fullscreen/imageDisplay.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';

class SewerageLiftingRequestList extends StatelessWidget {
  const SewerageLiftingRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SewerageLiftingRequestListPage(),
    );
  }
}
class SewerageLiftingRequestListPage extends StatefulWidget {
  const SewerageLiftingRequestListPage({super.key});

  @override
  State<SewerageLiftingRequestListPage> createState() => _GarbagePickupRequestListState();
}

class _GarbagePickupRequestListState extends State<SewerageLiftingRequestListPage> {

  get generalFunction => null;
  var status="Pending";
  List<Map<String, dynamic>>? cityzenRequestDetail;
  List<Map<String, dynamic>>? _filteredData;
  bool isLoading = true;

  // call a api
  cityzenRequestDetails() async {
    cityzenRequestDetail = await CitizenRequestDetailSewergeRepo().citizenRequestDetailsSewarge(context);
    print('-----37----xx --cityzenRequestDetail----$cityzenRequestDetail');
    _filteredData = List<Map<String, dynamic>>.from(cityzenRequestDetail ?? []);
    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // call a api
    cityzenRequestDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBack
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
              /// todo open HomePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ComplaintHomePage()),
              );
              //Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios,
                color: Colors.white,),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Sewerage Lifting Request List',
              style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          //centerTitle: true,
          elevation: 0, // Removes shadow under the AppBar
        ),
        body:
        isLoading
            ? Center(child:
        Container())
            : (cityzenRequestDetail == null || cityzenRequestDetail!.isEmpty)
            ? NoDataScreenPage()
            :
        Expanded(
            child: ListView.builder(
                itemCount: _filteredData?.length ?? 0,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _filteredData![index];
                  var iStatus = item['iStatus'];
                  return
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Background color
                                borderRadius: BorderRadius.circular(10),
                                // Rounded corners
                                border: Border.all(
                                    color: Colors.grey, width: 1), // Outer border
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.card_travel, size: 20,
                                                color: Colors.black54),
                                            const SizedBox(width: 5),
                                            Text(item['sAddress'], style: AppTextStyle
                                                .font12penSansExtraboldBlack45TextStyle)
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                                Icons.watch_later_rounded, size: 20,
                                                color: Colors.green),
                                            const SizedBox(width: 5),
                                            Text(item['dRequestTime'], style: AppTextStyle
                                                .font12penSansExtraboldBlack45TextStyle)
                                          ],
                                        ),
                                      ],

                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: (){
                                            print("---Open this image to full Dialog--");
                                            var image =  item['sImage_1'];
                                            print('---Images----160---$image');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FullScreenImages(image: image),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10), // Rounded corners
                                              color: Colors.grey[300], // Placeholder color while loading
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10), // Ensure rounded corners apply to the child
                                              child: Image.network(
                                                item['sImage_1'], // Replace with your network image URL
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(child: CircularProgressIndicator());
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.6),
                                              // Light gray with transparency
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on,
                                                    color: Colors.white, size: 16),
                                                const SizedBox(width: 8),
                                                // Spacing between icon and text
                                                Text(item['sMohalla'],
                                                  style: AppTextStyle
                                                      .font12penSansExtraboldWhiteTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, top: 10),
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
                                              Text('Citizen Remarks',
                                                  style: AppTextStyle
                                                      .font14penSansExtraboldBlack45TextStyle),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(item['sUserRemarks'],
                                              style: AppTextStyle
                                                  .font14penSansExtraboldBlack26TextStyle),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, top: 10),
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
                                              Text('Request Type',
                                                  style: AppTextStyle
                                                      .font14penSansExtraboldBlack45TextStyle),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(item['sRequestType'],
                                              style: AppTextStyle
                                                  .font14penSansExtraboldBlack26TextStyle),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // istatus
                                  Align(
                                    alignment: Alignment.centerRight,
                                    // Align container to right
                                    child: IntrinsicWidth( // Adjust width dynamically based on text
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Container(
                                          height: 30,
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          // Add padding around text
                                          decoration: BoxDecoration(
                                            color: iStatus == "Pending"
                                                ? Colors.yellow
                                                : Colors.green, // Background color
                                            borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(17),
                                                // Right top radius
                                                bottomRight: Radius.circular(17),
                                                // Right bottom radius
                                                topLeft: Radius.circular(17),
                                                bottomLeft: Radius.circular(17)
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                              "Status : ${item['iStatus']}",
                                              style: AppTextStyle
                                                  .font14penSansExtraboldWhiteTextStyle
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  iStatus!="Pending" ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 10, left: 10),
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
                                            Text('Driver Remarks',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack45TextStyle),
                                            SizedBox(width: 5),
                                            Text(" : ", style: TextStyle(
                                                color: Colors.black45),),
                                            SizedBox(width: 5),
                                            Text(item['sDriverRemarks'],
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),


                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, top: 0, left: 10),
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
                                                Text('Amount',
                                                    style: AppTextStyle
                                                        .font14penSansExtraboldBlack45TextStyle),
                                                SizedBox(width: 5),
                                                Text(" : ",
                                                  style: TextStyle(color: Colors.black45),),
                                                SizedBox(width: 5),
                                                Text('₹ ${item['fAmount']}',
                                                    style: AppTextStyle
                                                        .font14penSansExtraboldBlack26TextStyle),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    Icons.watch_later_rounded, size: 20,
                                                    color: Colors.green),
                                                const SizedBox(width: 5),
                                                Text(item['dResolvedTime'], style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle)
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ) :
                                  SizedBox()


                                ],
                              )
                          ),
                        ),
                      ],
                    );
                }
            )
        )
    );
  }
}


// class SewerageLiftingRequestList extends StatelessWidget {
//   const SewerageLiftingRequestList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SewerageLiftingRequestListPage(),
//     );
//   }
// }
// class SewerageLiftingRequestListPage extends StatefulWidget {
//   const SewerageLiftingRequestListPage({super.key});
//
//   @override
//   State<SewerageLiftingRequestListPage> createState() => _GarbagePickupRequestListState();
// }
//
// class _GarbagePickupRequestListState extends State<SewerageLiftingRequestListPage> {
//   get generalFunction => null;
//   var status="Pending";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBack
//       appBar: AppBar(
//         // statusBarColore
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Color(0xFF12375e),
//           statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
//           statusBarBrightness: Brightness.light, // For iOS (dark icons)
//         ),
//         // backgroundColor: Colors.blu
//         centerTitle: true,
//         backgroundColor: Color(0xFF255898),
//         leading: GestureDetector(
//           onTap: (){
//             print("------back---");
//             /// todo open HomePage
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) =>  ComplaintHomePage()),
//             );
//             //Navigator.pop(context);
//           },
//           child: const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(Icons.arrow_back_ios,
//               color: Colors.white,),
//           ),
//         ),
//         title: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5),
//           child: Text(
//             'Sewerge Lifting Request List ',
//             style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         //centerTitle: true,
//         elevation: 0, // Removes shadow under the AppBar
//       ),
//
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Background color
//                   borderRadius: BorderRadius.circular(10), // Rounded corners
//                   border: Border.all(color: Colors.grey, width: 1), // Outer border
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Icon(Icons.card_travel,size: 20,color: Colors.black54),
//                               const SizedBox(width: 5),
//                               Text("Ten Tower Ghaziabad",style: AppTextStyle.font12penSansExtraboldBlack45TextStyle)
//                             ],
//                           ),
//                           const Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Icon(Icons.watch_later_rounded,size: 20,color: Colors.green),
//                               const SizedBox(width: 5),
//                               Text("18/Feb/2025 17:32",style: AppTextStyle.font12penSansExtraboldBlack45TextStyle)
//                             ],
//                           ),
//                         ],
//
//                       ),
//                     ),
//                     SizedBox(
//                       height: 200,
//                       child: Stack(
//                         children: <Widget>[
//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10), // Rounded corners
//                               image: const DecorationImage(
//                                 image: AssetImage("assets/images/temple_4.png"), // Change to your image
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: Container(
//                               height: 35,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.6), // Light gray with transparency
//                                 borderRadius: const BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10),
//                                 ),
//                               ),
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.location_on, color: Colors.white,size: 16),
//                                   const SizedBox(width: 8), // Spacing between icon and text
//                                   Text(
//                                     "Bus Stand",
//                                     style: AppTextStyle.font12penSansExtraboldWhiteTextStyle,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                     ),
//                     SizedBox(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 5, top: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.black54
//                                   ),
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text('Citizen Remarks',
//                                     style: AppTextStyle
//                                         .font14penSansExtraboldBlack45TextStyle),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12),
//                             child: Text('Testing',
//                                 style: AppTextStyle
//                                     .font14penSansExtraboldBlack26TextStyle),
//                           ),
//                           SizedBox(height: 5),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 5, top: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.black54
//                                   ),
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text('Request Type',
//                                     style: AppTextStyle
//                                         .font14penSansExtraboldBlack45TextStyle),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12),
//                             child: Text('Garbage Pickup Request from House',
//                                 style: AppTextStyle
//                                     .font14penSansExtraboldBlack26TextStyle),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Align(
//                       alignment: Alignment.centerRight, // Align container to right
//                       child: IntrinsicWidth( // Adjust width dynamically based on text
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 5),
//                           child: Container(
//                             height: 30,
//                             padding: EdgeInsets.symmetric(horizontal: 10), // Add padding around text
//                             decoration: BoxDecoration(
//                               color: status == "Pending" ? Colors.yellow : Colors.green, // Background color
//                               borderRadius: const BorderRadius.only(
//                                   topRight: Radius.circular(17), // Right top radius
//                                   bottomRight: Radius.circular(17), // Right bottom radius
//                                   topLeft: Radius.circular(17),
//                                   bottomLeft: Radius.circular(17)
//                               ),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                                 "Status : Pending",
//                                 style: AppTextStyle
//                                     .font14penSansExtraboldBlack26TextStyle
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Divider(),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 5, top: 10,left: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black54
//                             ),
//                           ),
//                           SizedBox(width: 5),
//                           Text('Driver Remarks',
//                               style: AppTextStyle
//                                   .font14penSansExtraboldBlack45TextStyle),
//                           SizedBox(width: 5),
//                           Text(" : ",style: TextStyle(color: Colors.black45),),
//                           SizedBox(width: 5),
//                           Text('Garbage picked',
//                               style: AppTextStyle
//                                   .font14penSansExtraboldBlack26TextStyle),
//
//
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5, top: 0,left: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 width: 8,
//                                 height: 8,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.black54
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               Text('Amount',
//                                   style: AppTextStyle
//                                       .font14penSansExtraboldBlack45TextStyle),
//                               SizedBox(width: 5),
//                               Text(" : ",style: TextStyle(color: Colors.black45),),
//                               SizedBox(width: 5),
//                               Text('₹ 153789.0',
//                                   style: AppTextStyle
//                                       .font14penSansExtraboldBlack26TextStyle),
//                             ],
//                           ),
//                         ),
//                         Spacer(),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Icon(Icons.watch_later_rounded,size: 20,color: Colors.green),
//                               const SizedBox(width: 5),
//                               Text("18/Feb/2025 17:32",style: AppTextStyle.font14penSansExtraboldBlack26TextStyle)
//                             ],
//                           ),
//                         ),
//
//                       ],
//                     )
//
//
//
//                   ],
//                 )
//             ),
//           ),
//         ],
//
//       ),
//     );
//   }
// }
