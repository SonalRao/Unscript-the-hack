// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/fonts.dart';
import '../config/theme.dart';
import '../navbar.dart';
// import 'package:intl/intl.dart';
// import 'package:maps_launcher/maps_launcher.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key, required this.parkingDetails})
      : super(key: key);
  final Map parkingDetails;
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Map parkingDetails = {};
  LatLng? latlong;
  int? available;
  String? distance;
  double duration = 1;
  @override
  void initState() {
    super.initState();
    parkingDetails = widget.parkingDetails;
    print(parkingDetails);
    latlong = LatLng(double.parse(parkingDetails["lat"]),
        double.parse(parkingDetails["long"]));
    available = (parkingDetails["Columns"] * parkingDetails["Row"]) -
        parkingDetails["occupied"];
    distance = (parkingDetails["distance"] / 1000).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgLightGrey,
      appBar: AppBar(
        backgroundColor: Palette.bgLightGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.textBlack),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 100.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: 180.w,
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
                "$distance km",
                style: TextStyle(
                    fontSize: Fonts.smallText, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4.r),
                    blurRadius: 4.r,
                  )
                ]),
            width: 325.w,
            height: 225.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.r),
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
                        point: latlong!,
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
        ),
        SizedBox(
          height: 30.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            Icon(
              Icons.check_box,
              color: Palette.primary,
              size: 30.r,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              "Availability",
              style: TextStyle(fontSize: Fonts.smallHeading),
            )
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 75.w,
            ),
            Text(
              "$available",
              style: TextStyle(fontSize: Fonts.largeText),
            ),
            Text(
              " /${available! + (parkingDetails["occupied"])} slots",
              style: TextStyle(fontSize: Fonts.smallText),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 30.w,
            ),
            Icon(
              Icons.currency_rupee,
              color: Palette.primary,
              size: 30.r,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              "Rate",
              style: TextStyle(fontSize: Fonts.smallHeading),
            )
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 75.w,
            ),
            Text(
              "\u20B9${parkingDetails["Rate"]}",
              style: TextStyle(fontSize: Fonts.largeText),
            ),
            Text(
              " /hour",
              style: TextStyle(fontSize: Fonts.smallText),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        ElevatedButton(
          onPressed: () {
            Map bookingDetails = {};
            DateTime d = DateTime.now();
            DateTime t = DateTime.now();
            showModalBottomSheet(
                // isScrollControlled: true,
                backgroundColor: Palette.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r))),
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 20.w),
                      child: SizedBox(
                        height: 650.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking a slot",
                              style: TextStyle(
                                fontSize: Fonts.largeHeading,
                                color: Palette.textWhiteDark,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Select Date and Time",
                              style: TextStyle(
                                  fontSize: Fonts.smallText,
                                  color: Palette.textWhiteDark),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            DatePicker(
                              DateTime.now(),
                              selectionColor: Palette.primaryDark,
                              daysCount: 5,
                              initialSelectedDate: d,
                              selectedTextColor: Palette.textWhite,
                              onDateChange: (d1) {
                                d = d1;
                                print(d);
                              },
                            ),
                            Divider(
                              thickness: 0.5.sp,
                              height: 10.h,
                              color: Palette.textWhite,
                              indent: 3.w,
                              endIndent: 23.w,
                            ),
                            TimePickerSpinner(
                                is24HourMode: false,
                                isForce2Digits: true,
                                alignment: Alignment.centerLeft,
                                normalTextStyle: TextStyle(
                                  color: Palette.bgGrey,
                                  fontSize: Fonts.smallHeading,
                                ),
                                highlightedTextStyle: TextStyle(
                                    color: Palette.textWhite,
                                    fontSize: Fonts.largeHeading,
                                    fontWeight: FontWeight.w500),
                                itemWidth: 45.w,
                                itemHeight: 30.h,
                                spacing: 30.sp,
                                onTimeChange: (newTime) {
                                  t = newTime;
                                  print(t);
                                }),
                            Divider(
                              thickness: 0.5.sp,
                              height: 10.h,
                              color: Palette.textWhite,
                              indent: 3.w,
                              endIndent: 23.w,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Select Duration",
                              style: TextStyle(
                                  fontSize: Fonts.smallText,
                                  color: Palette.textWhiteDark),
                            ),
                            Slider(
                              value: duration,
                              activeColor: Palette.textWhite,
                              inactiveColor: Palette.primaryDark,
                              onChanged: (dur) {
                                // duration = dur;
                                setState(() {
                                  duration = dur;
                                });
                              },

                              min: 1.0,
                              max: 6.0,
                              // label: "Select number of hours",
                              divisions: 5,
                            ),
                            Center(
                              child: Text(
                                "$duration hours",
                                style: TextStyle(
                                  color: Palette.textWhite,
                                  fontSize: Fonts.smallHeading,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    bookingDetails["startTime"] = DateTime(
                                            d.year,
                                            d.month,
                                            d.day,
                                            t.hour,
                                            t.minute,
                                            t.second,
                                            t.millisecond)
                                        .toString();
                                    print(bookingDetails["Time"]);
                                    bookingDetails["Duration"] = duration;
                                    bookingDetails["placeName"] =
                                        parkingDetails["placeName"] +
                                            ", " +
                                            parkingDetails["Address"];
                                    bookingDetails["bookingTime"] =
                                        DateTime.now().toString();
                                    bookingDetails["slot"] = "A-17";
                                    bookingDetails["paymentAmount"] =
                                        (parkingDetails["Rate"] * duration);
                                    bookingDetails["lat"] =
                                        parkingDetails["lat"];
                                    bookingDetails["long"] =
                                        parkingDetails["long"];
                                    print(bookingDetails);
                                    Get.to(Navbar(
                                      index: 1,
                                      bookingDetails: bookingDetails,
                                    ));
                                  },
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontSize: Fonts.smallHeading,
                                        color: Palette.primary),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Palette.textWhite),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(141.w, 42.h)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17.r))),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: Fonts.smallHeading,
                                        color: Palette.red),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Palette.textWhite),
                                    fixedSize: MaterialStateProperty.all(
                                        Size(141.w, 42.h)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17.r))),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
                });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Palette.primary),
            fixedSize: MaterialStateProperty.all(Size(141.w, 42.h)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.r))),
          ),
          child: Text(
            "Book",
            style: TextStyle(fontSize: Fonts.smallHeading),
          ),
        ),
      ]),
    );
  }

  Widget bookingConfirmed(Map bookingDetails) {
    print(bookingDetails);
    int hrs = bookingDetails["Duration"].round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking\nConfirmed!",
                      style: TextStyle(
                          fontSize: Fonts.bigText,
                          color: Palette.textWhiteDark)),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text("Your Slot",
                      style: TextStyle(
                          fontSize: Fonts.smallText,
                          color: Palette.textWhiteDark)),
                  Text("A-17",
                      style: TextStyle(
                        fontSize: Fonts.hugeText,
                        color: Palette.textWhiteDark,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 45.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: SizedBox(
                height: 125.r,
                width: 125.r,
                child: QrImage(
                  data: jsonEncode(bookingDetails),
                  backgroundColor: Palette.textWhite,
                  padding: EdgeInsets.all(9.h),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, top: 15.h),
          child: Text("Timing",
              style: TextStyle(
                  fontSize: Fonts.smallText, color: Palette.textWhiteDark)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, top: 10.h),
          child: Text(
              "${formatDate(DateTime.parse(bookingDetails["startTime"]))},\n ${formatDate(DateTime.parse(bookingDetails["startTime"]).add(Duration(hours: hrs)))}",
              style: TextStyle(
                  fontSize: Fonts.largeText, color: Palette.textWhiteDark)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, top: 15.h),
          child: Text("Address",
              style: TextStyle(
                  fontSize: Fonts.smallText, color: Palette.textWhiteDark)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, top: 10.h, bottom: 20.h),
          child: Text("${bookingDetails["placeName"]}",
              style: TextStyle(
                  fontSize: Fonts.largeText, color: Palette.textWhiteDark)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Open In Map",
                style: TextStyle(
                    fontSize: Fonts.smallHeading, color: Palette.textWhiteDark),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Palette.green),
                fixedSize: MaterialStateProperty.all(Size(141.w, 42.h)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.r))),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.offAll(Navbar(
                  index: 0,
                ));
              },
              child: Text(
                "Go to Home",
                style: TextStyle(
                    fontSize: Fonts.smallHeading, color: Palette.textBlack),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Palette.textWhite),
                fixedSize: MaterialStateProperty.all(Size(141.w, 42.h)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.r))),
              ),
            ),
          ],
        )
      ],
    );
  }
}

String formatDate(DateTime d) {
  String date = "";
  Map months = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  date += d.day.toString() +
      " " +
      months[d.month] +
      " " +
      d.year.toString() +
      " , ";
  if (d.hour < 9 || (d.hour > 12 && (d.hour - 12) < 9)) {
    date += "0";
  }
  if (d.hour > 12) {
    date += (d.hour - 12).toString() + ":";
  } else {
    date += d.hour.toString() + ":";
  }
  if (d.minute < 10) {
    date += "0";
  }
  date += d.minute.toString();
  if (d.hour > 12) {
    date += " PM";
  } else {
    date += " AM";
  }
  return date;
}
