import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/login_register/auth_page_providers/login_page_provider.dart';
import 'package:quizy/src/view/login_register/forgot_pass_page/forgot_pass_page.dart';
import 'package:quizy/src/view/login_register/provider/login_reg_email_validation.dart';
import 'package:quizy/src/view/login_register/register/register_user.dart';
import 'package:quizy/src/view/login_register/services/auth_service.dart';
import 'package:quizy/src/view/login_register/widgets/custom_button.dart';
import 'package:quizy/src/view/login_register/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();

  final pass = TextEditingController();

  final formkey = GlobalKey<FormState>();

  final LoginRegEmailValidation validator = LoginRegEmailValidation();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   gradient: RadialGradient(colors: [Colors.indigo, Colors.blueAccent]),
        // ),
        color: AppTheme.primaryColor,
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Center(
                    child: SvgPicture.asset(
                      "assets/img/logiin.svg",
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Text(
                    "Stay with us...",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Dancing',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
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
                  SizedBox(height: 20),
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
                          onTap: context.read<LoginPageProvider>().toggle,
                          child: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),

                        controller: pass,
                        validator: (value) {
                          return validator.passValidation(pass.text);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Forgot Password",
                          style: TextStyle(
                            color: Colors.white,

                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassPage(),
                                    ),
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: CustomButton(
                      color: Colors.indigo,
                      onpress: () {
                        bool info = formkey.currentState!.validate();
                        if (info) {
                          _authService.loginUser(
                            email.text,
                            pass.text,
                            context,
                          );
                        }
                      },
                      width: 120,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: " Register",
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
                                        builder: (context) => RegisterPage(),
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
