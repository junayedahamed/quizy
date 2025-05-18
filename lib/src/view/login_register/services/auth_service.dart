import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizy/src/view/admin/admin_home_screen.dart';
import 'package:quizy/src/view/login_register/login/login_page.dart';
import 'package:quizy/src/view/user/home_screen.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> signUp(
    String email,
    String pass,
    String role,
    String name,
    context,
  ) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await _firebaseFirestore.collection('rolesNames').doc(res.user!.uid).set({
        'email': email,
        'name': name,
        'role': role,
      });
      Fluttertoast.showToast(
        msg: 'Account created successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      log('here');
      // return 'success';
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'This password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exist on this email';
      } else {
        message = e.code;
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
      // log("here2");
      // return 'exception';
    }
  }

  Future<Map<String, dynamic>?> signIn(String email, String pass) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final userDoc =
          await _firebaseFirestore
              .collection('rolesNames')
              .doc(res.user!.uid)
              .get();
      // log(userDoc.reference.toString());
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        // log(data['role']);
        // log(data.toString());
        return {
          'uid': res.user!.uid,
          'email': data['email'],
          'role': data['role'],
        };
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'User not found';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else {
        message = e.code;
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
      return null;
    }
  }

  logOut(context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) {
        return false;
      },
    );
  }

  Future<void> forgotPass(String email, context) async {
    final alluser = await _firebaseFirestore.collection('rolesNames').get();
    List<String> emails = [];
    for (var doc in alluser.docs) {
      final data = doc.data();
      emails.add(data['email']);
    }

    var result = emails.where((ema) {
      return ema.contains(email);
    });

    if (result.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "Enter your account email",
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  void loginUser(String email, String password, dynamic context) async {
    final authService = AuthService();
    // print("object");

    final userData = await authService.signIn(email, password);
    // print(userData);
    if (userData != null) {
      final role = userData['role'];

      if (role == 'teacher') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else if (role == 'student') {
        Navigator.push(
          context,

          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      // show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }
}
