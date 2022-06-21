// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, duplicate_ignore, prefer_const_constructors, unused_local_variable

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../backend/backend.dart';
import '../config/theme.dart';
import '../navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> labels = ['User', 'Admin'];
  int counter = 0;
  String selector = '';

  var isSelected = const Text("User");
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    // TextEditingController controller;
    TextEditingController controller;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFFEFFFE),
        // ignore: prefer_const_literals_to_create_immutables
        body: SingleChildScrollView(
          child: Column(children: [
            // ignore: prefer_const_constructors
            Image.asset(
              'assets/images/logo_name.png',
              scale: 1,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                Container(
                  // color: Palette.bgLightGrey,
                  decoration: BoxDecoration(
                      color: Palette.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRadioButton(
                        // ignore: prefer_const_constructors
                        buttonTextStyle: ButtonTextStyle(
                            selectedColor: Palette.textBlack,
                            unSelectedColor: Palette.textBlackLight),
                        radioButtonValue: (text) {
                          if (text == 'user') {
                            print('user');
                            selector = '/register';
                          } else {
                            print('admin');
                            selector = '/registerAdmin';
                          }
                        },
                        enableShape: true,
                        radius: 500,
                        width: 100.w,
                        defaultSelected: "user",
                        selectedBorderColor: Palette.primaryDark,
                        unSelectedBorderColor: Palette.primary,
                        buttonLables: ['USER', 'ADMIN'],
                        buttonValues: ['user', 'admin'],
                        unSelectedColor: Palette.primary,
                        selectedColor: Palette.primaryDark),
                  ),
                ),
                Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: 320.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Palette.primary),
                child: TextField(
                  cursorColor: Palette.textBlackDark,
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail, color: Palette.bgLightGrey),
                    hintText: 'Enter Email',
                    border: InputBorder.none,
                  ),
                  // controller: controller,
                  onChanged: (text) {
                    if (text != '') {
                      setState(() {
                        email = text;
                      });
                    }
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: 320.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Palette.primary),
                child: TextField(
                  obscureText: true,
                  cursorColor: Palette.textBlackDark,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Palette.bgLightGrey),
                    hintText: 'Enter Password',
                    border: InputBorder.none,
                  ),
                  // controller: controller,
                  onChanged: (text) {
                    if (text != '') {
                      setState(() {
                        password = text;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            InkWell(
                onTap: () {
                  if (selector == '/register') {
                    Map data = {"email": email, "password": password};
                    setState(() {
                      print(selector);
                      Backend().sendData(selector, data);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Navbar(
                                    index: 0,
                                  )));
                    });
                  } else {
                    if (email == "" || password == "") {
                      print("Please enter all details");
                    }
                    Map data = {"email": email, "password": password};
                    setState(() {
                      print(selector);
                      Backend().sendData(selector, data).whenComplete(() {
                        if (Backend().getStatusCode() == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navbar(
                                        index: 0,
                                      )));
                        } else {
                          print("Error creating Account");
                        }
                      });
                    });
                  }
                },
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Navbar(
                                  index: 0,
                                )));
                  },
                  child: Text('LOGIN'),
                )),
          ]),
        ),
      ),
    );
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cancel),
        SizedBox(
          width: 12.0,
        ),
        Text('errorMessage'),
      ],
    ),
  );
}
