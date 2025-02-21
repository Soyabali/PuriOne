import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class GetWasteTypeRepo
{
  List bindcomplaintSubList = [];

  Future<List> getWasteType() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');



    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetWasteType/GetWasteType";
      var bindComplaintsubApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindComplaintsubApi'));

      // request.body = json.encode({
      //   "iCategoryCode": code,
      // });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindcomplaintSubList = parsedJson['Data'];
        print("Dist list Marklocation Api ----71------>:$bindcomplaintSubList");
        return bindcomplaintSubList;
      } else
      {
        hideLoader();
        return bindcomplaintSubList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
