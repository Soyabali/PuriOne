import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class PostCitizenRequestMobileRepo {
  GeneralFunction generalFunction = GeneralFunction();


  Future postCitizenRequest(
      BuildContext context, String address, String landmark,
      String remarks, selectedNameWasteType,
      dropDownValueWard, uplodedImage, lat, long
    ) async {
     // to fetch value from a local database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('sToken');
    var sContactNo = prefs.getString('sContactNo');

    //
    print('----address---$address');
    print('----landmark---$landmark');
    print('----remarks---$remarks');
    print('----selectedNameWasteType---$selectedNameWasteType');
    print('----dropDownValueWard---$dropDownValueWard');
    print('----uplodedImage---$uplodedImage');
    print('----lat---$lat');
    print('----long---$long');
    print('-----sContactNo--$sContactNo');

    // sharedP

    print('---token ---$token');
    print('---sContactNo ---$sContactNo');
    try {
      var baseURL = BaseRepo().baseurl;
      /// TODO CHANGE HERE
      var endPoint = "PostCitizenRequestMobile/PostCitizenRequestMobile";
      var postCityzenRequestApi = "$baseURL$endPoint";


      // String jsonResponse =
      //     '{"sArray":[{"iCompCode":$randomNumber,"iSubCategoryCode":$dropDownValueComplaintSubCategory,"sWardCode":$dropDownValueWard,"sAddress":"NA","sLandmark":"NA","sComplaintDetails":"NA","sComplaintPhoto":$uplodedImage,"sPostedBy":$sContactNo,"fLatitude":"28.8765","fLongitude":"77.9898"}]}';

      String jsonResponse =
          '{"sArray":[{"sAddress":"$address","sMohalla":"$landmark","sUserRemarks":"$remarks","iWasteType":"$selectedNameWasteType","sRequestTypeCode":"$dropDownValueWard","sImage_1":"$uplodedImage","sWardCode":"NA","fLat":"$lat","fLon":"$long","sContactNo":"$sContactNo"}]}';


      // Parse the JSON response
      Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);

// Get the array value
      List<dynamic> sArray = parsedResponse['sArray'];

// Convert the array to a string representation
      String sArrayAsString = jsonEncode(sArray);

// Update the response object with the string representation of the array
      parsedResponse['sArray'] = sArrayAsString;

// Convert the updated response object back to JSON string
      String updatedJsonResponse = jsonEncode(parsedResponse);

// Print the updated JSON response (optional)
      print(updatedJsonResponse);
      print('---63-----$updatedJsonResponse');

//Your API call
      var headers = {'token': '$token', 'Content-Type': 'application/json'};

      var request = http.Request(
          'POST', Uri.parse(postCityzenRequestApi));

      request.body = updatedJsonResponse; // Assign the JSON string to the request body
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---90---${response.statusCode}');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------96-----$map');
        return map;
      } else if(response.statusCode==401)
      {
        generalFunction.logout(context);
      }else{
        print('----------99----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}
