// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../booking screens/parking_details.dart';
import '../config/fonts.dart';
import '../config/theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? loc;
  LatLng? latLong = LatLng(18.59, 73.80);
  @override
  void initState() {
    super.initState();
    getLocation().then((value) => setState(() {}));
    print(latLong);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getLocation() async {
    Position _locationData = await _getGeoLocationPosition();
    setState(() {
      getAddress(_locationData.latitude, _locationData.longitude);
      latLong = LatLng(_locationData.latitude, _locationData.longitude);
    });
  }

  Future<void> getAddress(double lat, double lon) async {
    Future<List<geo.Placemark>> places = geo.placemarkFromCoordinates(lat, lon);
    places.then((value) {
      // print(value);
      geo.Placemark p = value[0];
      setState(() {
        loc = "${p.subLocality}, ${p.locality}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: 800.sp,
      child: Stack(
        children: [
          //map
          Container(
            color: Palette.primaryLight,
            child: FlutterMap(
              options: MapOptions(
                center: latLong,
                zoom: 13,
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
                      width: 80.sp,
                      height: 80.sp,
                      rotate: true,
                      point: latLong!,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Palette.red,
                        size: 50.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.sp),
              child: ElevatedButton(
                  onPressed: () {
                    // getLocation();
                    Get.to(ParkingDetails(
                      latlong: latLong!,
                    ));
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(235.w, 45.h)),
                    backgroundColor: MaterialStateProperty.all(Palette.primary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r))),
                  ),
                  child: Text(
                    "Book Parking",
                    style: TextStyle(
                      fontSize: Fonts.largeText,
                      color: Palette.textWhite,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Opacity(
              opacity: 0.7,
              child: Container(
                width: 375.w,
                height: 49.h,
                decoration: BoxDecoration(
                  color: Palette.textWhiteDark,
                  boxShadow: [
                    BoxShadow(blurRadius: 4.sp, offset: Offset(0, 4.sp))
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Palette.textBlack),
                      Text(
                        loc ?? "-",
                        style: TextStyle(
                            fontSize: Fonts.smallHeading,
                            fontWeight: FontWeight.w500,
                            color: Palette.textBlack),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
