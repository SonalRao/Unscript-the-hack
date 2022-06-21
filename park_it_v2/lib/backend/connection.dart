import 'dart:convert';

import 'package:http/http.dart' as http;

// String url = 'http://10.0.2.2:3000'; //Pinak
// String url = 'http://192.168.1.8:3000'; //Mrun
String url = "https://parkit-04.herokuapp.com";

class UserBooking {
  Future<Map> getAllParkingDetails(double lat, double lon) async {
    Map data = {};
    Uri uri = Uri.parse(url + "/allparkingdetails");
    Map jsonBody = {"lat": lat.toString(), "long": lon.toString()};
    print(jsonBody);
    var response = await http.post(uri, body: jsonBody);
    data = jsonDecode(response.body);
    return data;
  }

  Future<Map> createBooking(Map bookingData,)async{
    Map data = {};
    Uri uri = Uri.parse(url + "/createBooking");
   
    /*userId,
            parkingId,
            PaymentAmount,
            Duration,
            Time,
            PaymentConfirmation,
            PlaceName,
            NumberPlate, */
    var response = await http.post(uri, body: bookingData);
    data = jsonDecode(response.body);
    return data;
  }
}
