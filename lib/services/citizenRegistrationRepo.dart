import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class CitizenRegistrationRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future citizenRegistration(BuildContext context, String name, String phone) async {

    try {
      print('----phone-----17--$phone');
      print('----name-----17--$name');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "CitizenRegistration/CitizenRegistration";
      var registrationApi = "$baseURL$endPoint";
      print('------------17---registrationApi---$registrationApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$registrationApi'));
      request.body = json.encode(
          {
            "sContactNo": phone,
            "sCitizenName": name,
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---Registration response----$map');
       if(response.statusCode==401){
         generalFunction.logout(context);
       }
      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---Registration response----$map');
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
