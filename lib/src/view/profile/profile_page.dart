import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/login_register/services/auth_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  Map<String, dynamic> data = {};
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final udoc =
        await _firebaseFirestore
            .collection('rolesNames')
            .doc(_firebaseAuth.currentUser!.uid)
            .get();

    setState(() {
      data = udoc.data() ?? {};
      _isloading = false;
    });
    // log(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Skeletonizer(
        enabled: _isloading,
        effect: ShimmerEffect(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: 150,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 50,
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.person, color: AppTheme.primaryColor),
                    Text(
                      "Name: ${(data['name'] ?? '').toString().toUpperCase()}",
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 2),
              Divider(),
              SizedBox(
                height: 50,
                child: Row(
                  spacing: 10,
                  children: [
                    Image.asset(
                      'assets/img/role.png',
                      height: 30,
                      width: 30,
                      color: AppTheme.primaryColor,
                    ),
                    Text(
                      " Role:  ${data['role'] != null && data['role'].toString().isNotEmpty ? data['role'] : ''}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Expanded(child: SizedBox()),
                    if (data['role'] != null)
                      data['role'] == 'teacher'
                          ? SvgPicture.asset(
                            'assets/img/logiin.svg',
                            height: 40,
                            width: 40,
                          )
                          : SizedBox(),
                    SizedBox(width: 1),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 2),
              Divider(),
              SizedBox(
                height: 50,
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.email_outlined, color: AppTheme.primaryColor),

                    Text(
                      _firebaseAuth.currentUser!.email.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 2),
              Divider(),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      spacing: 3,
                      children: [
                        Icon(Icons.verified, color: AppTheme.primaryColor),
                        Text("Satus: ", style: TextStyle(fontSize: 18)),
                      ],
                    ),

                    Container(
                      height: 25,
                      width: 105,
                      decoration: BoxDecoration(
                        color:
                            _firebaseAuth.currentUser!.emailVerified
                                ? Colors.green
                                : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          _firebaseAuth.currentUser!.emailVerified
                              ? "Verified"
                              : " Unauthorized",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 2),
              SizedBox(height: 35),
              Center(
                child: InkWell(
                  onTap: () {
                    _authService.logOut(context);
                  },
                  child: SizedBox(
                    height: 80,
                    width: 90,
                    child: Image.asset(
                      'assets/img/logout.gif',
                      // fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
