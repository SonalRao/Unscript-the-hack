// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, avoid_print
//add the back button functionality and logout functionality.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/fonts.dart';
import '../config/theme.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  get fontsize => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.primary,
        elevation: 0,
        // leading: Icon(Icons.arrow_back, ),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: Fonts.largeHeading),
        ),
        centerTitle: true,
      ),
      backgroundColor: Palette.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //for circle avtar image
          _getHeader(),
          SizedBox(
            height: 8.h,
          ),
          _heading("Personal Details"),
          SizedBox(
            height: 4.h,
          ),
          _detailsCard(),
          SizedBox(
            height: 18.h,
          ),
          _heading("Settings"),
          SizedBox(
            height: 4.h,
          ),
          _settingsCard(),
          SizedBox(
            height: 40.h,
          ),
          logoutButton()
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 70.r,
              width: 70.r,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  shape: BoxShape.circle,
                  color: Palette.bgLightGrey,
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/profile_pic.png'),
                  )
                  // color: Colors.orange[100],
                  ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          _profileName("Pamela R Anderson"),
          Spacer(
            flex: 1,
          ),
          IconButton(
              splashRadius: 30,
              onPressed: () {
                print('Profile Pic edit clicked');
              },
              icon: Icon(
                Icons.edit,
                color: Palette.bgGrey,
              )),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _profileName(String name) {
    return SizedBox(
      width: 210.w,
      height: 24.h,
      child: Text(
        name,
        style: TextStyle(
            color: Palette.textWhiteDark,
            fontSize: 24,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _heading(String heading) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: SizedBox(
        width: 174.w, //80% of width,
        child: Text(
          heading,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: Fonts.heading,
              color: Palette.textWhite,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(
                Icons.email,
                color: Palette.grey,
              ),
              title: Text("pamelaranderson@gmail.com"),
            ),
            Divider(
              height: 0.6,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.card_membership_rounded,
                color: Palette.grey,
              ),
              title: Text("Validity: September 2022"),
            ),
            Divider(
              height: 0.6,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Palette.grey,
              ),
              title: Text("********"),
              trailing: Icon(
                Icons.edit,
                color: Palette.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(Icons.reviews_rounded),
              title: Text("Rate Us"),
            ),
            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(Icons.dashboard_customize),
              title: Text("About Us"),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Spacer(),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Palette.textWhite)),
            onPressed: () {
              print('Logged Out');
            },
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Icon(
                  Icons.logout,
                  color: Palette.red,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "LOGOUT",
                  style: TextStyle(color: Palette.red, fontSize: 18),
                ),
              ],
            )),
        Spacer()
      ],
    );
  }
}
