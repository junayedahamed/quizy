import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/login_register/auth_page_providers/login_page_provider.dart';
import 'package:quizy/src/view/login_register/login/login_page.dart';
import 'package:quizy/src/view/login_register/provider/login_reg_email_validation.dart';
import 'package:quizy/src/view/login_register/services/auth_service.dart';
import 'package:quizy/src/view/login_register/widgets/custom_button.dart';
import 'package:quizy/src/view/login_register/widgets/custom_text_field.dart';

enum Role { teacher, student }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final List<String> role = ['user', 'admin'];
  final email = TextEditingController();

  final pass = TextEditingController();

  final role = TextEditingController();

  final confpass = TextEditingController();

  final uname = TextEditingController();

  final formkey = GlobalKey<FormState>();

  final LoginRegEmailValidation validator = LoginRegEmailValidation();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // gradient: RadialGradient(colors: [Colors.indigo, Colors.blueAccent]),
          color: AppTheme.primaryColor,
        ),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: SvgPicture.asset(
                      'assets/img/reg.svg',
                      height: 120,
                      width: 120,
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Be connected with Quizy.......',
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Dancing',
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                    // Optional: set to null for infinite
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  SizedBox(height: 9),
                  Text(
                    "User name",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  CustomTextFormField(
                    controller: uname,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'User name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  Text(
                    "Email",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  CustomTextFormField(
                    controller: email,
                    validator: (value) {
                      return validator.validateEmail(email.text);
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  BlocBuilder<LoginPageProvider, bool>(
                    builder: (context, value) {
                      return CustomTextFormField(
                        obscureText: value,
                        suffixIcon: GestureDetector(
                          onTap: context.read<LoginPageProvider>().toggle2,
                          child: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),

                        controller: pass,
                        validator: (value) {
                          return validator.passValidationReg(
                            pass.text,
                            confpass.text,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 35),
                  Text(
                    "Confirm password",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  BlocBuilder<LoginPageProvider, bool>(
                    builder: (context, value) {
                      return CustomTextFormField(
                        obscureText: value,
                        suffixIcon: GestureDetector(
                          onTap: context.read<LoginPageProvider>().toggle,
                          child: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),

                        controller: confpass,
                        validator: (value) {
                          return validator.passValidationReg(
                            pass.text,
                            confpass.text,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select your category",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: DropdownButtonFormField<Role>(
                          hint: Text("Select one"),

                          // style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                            ),

                            fillColor: Colors.transparent,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          items:
                              Role.values
                                  .map(
                                    (each) => DropdownMenuItem(
                                      alignment: Alignment.bottomLeft,
                                      value: each,
                                      child: Text(
                                        each.name[0].toUpperCase() +
                                            each.name.substring(1),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Select one";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            role.text = value!.name;
                            log(role.text);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),

                  Center(
                    child: CustomButton(
                      color: Colors.indigo,
                      onpress: () {
                        bool info = formkey.currentState!.validate();
                        if (info) {
                          final val = _authService.signUp(
                            email.text,
                            pass.text,
                            role.text,
                            uname.text,
                          );

                          String status = '';
                          val.then((onValue) {
                            setState(() {
                              status = onValue;
                            });
                          });
                          if (status == 'success') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          }
                        }

                        //  else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text("Invalid email or pass")),
                        //   );
                        // }
                      },
                      width: 120,
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: " Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
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
