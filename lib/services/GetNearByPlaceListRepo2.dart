

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetNearByPlaceListRepo2 {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> getNearByPlacelist(BuildContext context, lat2, long2, iTypeCodeUtilities) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');
    String? contactNo = prefs.getString('sContactNo');

    print('---contact no---$contactNo');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetNearByPlaceList/GetNearByPlaceList";
      var citiZenPoatComplaintApi = "$baseURL$endPoint";

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$citiZenPoatComplaintApi'));
      // hide the body

      request.body = json.encode({
        "fLatitude": lat2,
        "fLongitude":long2,
        "iTypeCode":iTypeCodeUtilities
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if(response.statusCode ==401){
        generalFunction.logout(context);
      }
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['Data'];

        if (dataList != null) {
          List<Map<String, dynamic>> pendingInternalComplaintList = dataList.cast<Map<String, dynamic>>();
          print("Dist list: $pendingInternalComplaintList");
          return pendingInternalComplaintList;
        } else if(response.statusCode==401) {
          generalFunction.logout(context);
        }
      } else {
        hideLoader();
        return null;
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
      throw e;
    }
  }
}