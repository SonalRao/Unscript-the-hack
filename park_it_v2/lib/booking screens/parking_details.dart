import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:park_it_v2/backend/connection.dart';
import 'package:park_it_v2/config/fonts.dart';
import 'package:park_it_v2/config/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import 'booking_screen.dart';

class ParkingDetails extends StatefulWidget {
  const ParkingDetails({Key? key, required this.latlong}) : super(key: key);
  final LatLng latlong;
  @override
  _ParkingDetailsState createState() => _ParkingDetailsState();
}

class _ParkingDetailsState extends State<ParkingDetails> {
  List parkingData = [];
  LatLng? latlong;
  bool isLoading = true;
  List dummy = [
    {
      "name": "Westend Mall",
      "lat": 18.49,
      "lon": 73.80,
      "distance": "7.5 km",
      "available": 34,
      "area": "DP Road, Aundh",
      "totalslots": 75,
      "rate": 15
    },
    {
      "name": "Spot 18",
      "lat": 18.59,
      "lon": 73.82,
      "distance": "2 km",
      "available": 5,
      "area": "Shivar Chowk, Pimple Saudagar",
      "totalslots": 45,
      "rate": 12
    },
    {
      "name": "BRT Parking",
      "lat": 18.53,
      "lon": 73.76,
      "distance": "1.6 km",
      "available": 15,
      "area": "Govind Yashada Chowk, Pimple Saudagar",
      "totalslots": 100,
      "rate": 15
    }
  ];
  @override
  void initState() {
    super.initState();
    latlong = widget.latlong;
    UserBooking()
        .getAllParkingDetails(latlong!.latitude, latlong!.longitude)
        .then((value) {
      setState(() {
        // print(value);
        parkingData = value["allUsers"] ?? dummy;
        // print(parkingData);
        parkingData.sort((a, b) => (a['distance']).compareTo(b['distance']));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                    child: lottie.Lottie.asset(
                      "assets/lottiefiles/location_loading.json",
                    ),
                  ),
                  Text(
                    "Locating nearby parking spaces...",
                    style: TextStyle(
                      fontSize: Fonts.smallHeading,
                      fontWeight: FontWeight.w500,
                      color: Palette.textWhite,
                    ),
                  )
                ],
              ),
            )
          : parkingData.isEmpty
              ? Center(
                  child: Text(
                    "No nearby parking areas!",
                    style: TextStyle(
                        fontSize: Fonts.smallHeading,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: List.generate(parkingData.length,
                        (index) => getParkingDetailsCard(parkingData[index])),
                  ),
                ),
    );
  }

  Widget getParkingDetailsCard(Map parkingDetails) {
    LatLng latlong = LatLng(double.parse(parkingDetails["lat"]),
        double.parse(parkingDetails["long"]));
    int available = (parkingDetails["Columns"] * parkingDetails["Row"]) -
        parkingDetails["occupied"];
    String distance = (parkingDetails["distance"] / 1000).toStringAsFixed(2);
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 30.w,
        vertical: 5.h,
      ),
      child: Center(
        child: Container(
          width: 345.w,
          decoration: BoxDecoration(
            color: Palette.textWhite,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ExpandablePanel(
            header: SizedBox(
              height: 100.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 35.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          parkingDetails["placeName"],
                          style: TextStyle(
                              fontSize: Fonts.smallHeading,
                              fontWeight: FontWeight.w500),
                          // overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          width: 165.w,
                          child: Text(
                            parkingDetails["Address"],
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(fontSize: Fonts.paragraph),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Palette.grey,
                  ),
                  Text(
                    "${distance} km",
                    style: TextStyle(
                        fontSize: Fonts.smallText, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            collapsed: Container(),
            expanded: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 275.w,
                      height: 130.h,
                      child: FlutterMap(
                        options: MapOptions(
                          center: latlong,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 80.w,
                                height: 80.h,
                                rotate: true,
                                point: latlong,
                                builder: (ctx) => Icon(
                                  Icons.location_on,
                                  color: Palette.red,
                                  size: 40.r,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Palette.grey,
                      ),
                      Text("$available available"),
                      SizedBox(
                        width: 75.w,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Palette.primary),
                          ),
                          onPressed: () {
                            Get.to(
                                BookingScreen(parkingDetails: parkingDetails));
                          },
                          child: const Text(
                            "Book",
                            style: TextStyle(color: Palette.textWhite),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
