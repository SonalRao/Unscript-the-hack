// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import '../config/fonts.dart';
import '../config/theme.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({Key? key, this.bookingDetails}) : super(key: key);
  final Map? bookingDetails;

  @override
  _BookingStatusState createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  LatLng parking = LatLng(18.59, 73.80);
  Map bookingDetails = {};
  int hrs = 0;
  DateTime bookingDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    //check if booking present
    if (bookingDetails.isNotEmpty) {
      double duration = bookingDetails["Duration"] ?? 0;
      hrs = duration.round();
      bookingDate =
          DateTime.tryParse(bookingDetails["startTime"]) ?? DateTime.now();
      parking = LatLng(bookingDetails['lat'], bookingDetails['long']);
    }
    bookingDetails = widget.bookingDetails ?? {};

    print(bookingDetails);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Palette.primary,
          child: bookingDetails.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lottiefiles/no_bookings.json",
                          height: 150.h),
                      Text("No current booking!",
                          style: TextStyle(
                              fontSize: Fonts.largeText,
                              color: Palette.textWhiteDark)),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              fontSize: Fonts.smallText,
                              color: Palette.textWhiteDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: Text(
                          "${formatDate(bookingDate)},\n ${formatDate(bookingDate.add(Duration(hours: hrs)))}",
                          style: TextStyle(
                              fontSize: Fonts.largeText,
                              color: Palette.textWhiteDark)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 15.h),
                      child: Text("Address",
                          style: TextStyle(
                              fontSize: Fonts.smallText,
                              color: Palette.textWhiteDark)),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.w, top: 10.h, bottom: 20.h),
                      child: Text("${bookingDetails["placeName"]}",
                          style: TextStyle(
                              fontSize: Fonts.largeText,
                              color: Palette.textWhiteDark)),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          String googleUrl =
                              'https://www.google.com/maps/search/?api=1&query=${parking.latitude},${parking.longitude}';
                          launchUrl(Uri.parse(googleUrl));
                        },
                        child: Text(
                          "Open In Map",
                          style: TextStyle(
                              fontSize: Fonts.smallHeading,
                              color: Palette.textWhiteDark),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.green),
                          fixedSize:
                              MaterialStateProperty.all(Size(187.w, 36.h)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.r))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            bookingDetails = {};
                          });
                        },
                        child: Text(
                          "Cancel Booking",
                          style: TextStyle(
                              fontSize: Fonts.smallHeading,
                              color: Palette.textBlack),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.textWhite),
                          fixedSize:
                              MaterialStateProperty.all(Size(187.w, 36.h)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.r))),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
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
}
