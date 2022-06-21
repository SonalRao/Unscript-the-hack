// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, avoid_print

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'config/theme.dart';
import 'homescreen/homepage.dart';
import 'main_screens/qr_code.dart';
import 'profilescreen/profile_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key, required this.index, this.bookingDetails})
      : super(key: key);
  final int index;
  final Map? bookingDetails;
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int i = 0;
  Map? bookingDetails;
  @override
  void initState() {
    super.initState();
    setState(() {
      i = widget.index;
      bookingDetails = widget.bookingDetails;
      getPage(i);
    });
  }

  Widget body = Container();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body,
        bottomNavigationBar: CurvedNavigationBar(
          index: i,
          height: 65.h,
          backgroundColor: Palette.primary,
          items: const [
            Icon(
              Icons.home,
            ),
            Icon(
              Icons.qr_code,
            ),
            Icon(
              Icons.person,
            ),
          ],
          onTap: (int index) {
            getPage(index);
          },
        ),
      ),
    );
  }

  void getPage(int index) {
    switch (index) {
      case 0:
        {
          setState(() {
            body = Homepage();
            i = index;
          });

          break;
        }
      case 1:
        {
          setState(() {
            body = BookingStatus(
              bookingDetails: bookingDetails,
            );
            i = index;
            print(i);
          });
          break;
        }
      case 2:
        {
          setState(() {
            body = ProfileScreen();
            i = index;
          });
          break;
        }
    }
  }
}
