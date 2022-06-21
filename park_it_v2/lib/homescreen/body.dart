// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../booking screens/booking_screen.dart';
import '../profilescreen/profile_screen.dart';
import 'homepage.dart';


class HomeBody extends StatefulWidget {
  const HomeBody({required Key key, @required this.index}) : super(key: key);
  final index;

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  HomeBody get widget => super.widget;
  int index = 0;
  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      index = widget.index;
    });
    return buildPage(context, index);
  }
}

Widget buildPage(BuildContext context, int index) {
  switch (index) {
    case 0:
      {
        index = 0;
        return const Homepage();
      }
    case 1:
      {
        index = 1;
        return const BookingScreen(
          parkingDetails: {},
        );
      }
    case 2:
      {
        index = 2;
        return const ProfileScreen();
      }
  }
  return Container();
}
