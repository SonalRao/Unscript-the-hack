// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

// String url = 'http://10.0.2.2:3000'; //Pinak
// String url = 'http://192.168.1.8:3000'; //Mrun
String url = "https://parkit-04.herokuapp.com";
String? uid;
String? aid;
String? currentBookingId;
Map? jsonData;
int? statusCode;
String? userNumberPlate;

class Backend {
  Backend();
  String getID() {
    return uid!;
  }

  String getParkingID() {
    return aid!;
  }

  String getCurrentBookingId() {
    return currentBookingId!;
  }

  Map getData() {
    return jsonData!;
  }

  int getStatusCode() {
    return statusCode!;
  }

  String getNoPlate() {
    return userNumberPlate!;
  }

  Future<Map?> fetchData(String page) async {
    final response = await http.get(Uri.parse(url+ page));
    statusCode = response.statusCode;
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      jsonData = jsonDecode(data);
      return jsonData;
    } else {
      return {"errorMessage": 'Error fetching data'};
    }
  }

  Future<Map?> sendData(String page, Map jsonFile) async {
    print("Sending data");
    final response = await http.post(Uri.parse(url+ page), body: jsonFile);
    String data = response.body;

    statusCode = response.statusCode;
    print(data);
    if (statusCode == 200) {
      jsonData = jsonDecode(data);
      if (page == "/register" || page == "/signin") {
        userNumberPlate = jsonData!["carNumber"];
        List recent = jsonData!["recentBookings"];
        currentBookingId = null;
        uid = jsonData!["_id"];
      }
      if (page == "/registerAdmin" || page == "/adminSignin") {
        aid = jsonData!["_id"];
      }
      if (page == "/createBooking") {
        currentBookingId = jsonData!["BookingId"];
      }
      if (page.contains("/cancelBooking")) {
        print("Cancelling booking");
        currentBookingId = null;
        print(currentBookingId);
      }
      if (page.contains("")) {}

      return jsonData;
    }

    return null;
  }
}


/* void signIn() async {
  final response = await http.post('http://10.0.2.2:3000' + '/register', body: {
    "fullname": "Sonal rao",
    "email": "sonalmrao@gmail.com",
    "password": "sample123",
    "cpassword": "sample123",
    "phoneNumber": "9234737385"
  });
  if (response.statusCode == 200) {
    print('ho gaya');
  } else {
    print(response.body);
  }
} */



void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var url =
      Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;
    var itemCount = jsonResponse['totalItems'];
     print('Number of books about http: $itemCount.');
   } else {
    print('Request failed with status: ${response.statusCode}.');
   }
 }
