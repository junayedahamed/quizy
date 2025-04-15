import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/login_register/provider/login_reg_email_validation.dart';
import 'package:quizy/src/view/login_register/services/auth_service.dart';
import 'package:quizy/src/view/login_register/widgets/custom_button.dart';
import 'package:quizy/src/view/login_register/widgets/custom_text_field.dart';

class ForgotPassPage extends StatelessWidget {
  ForgotPassPage({super.key});
  final email = TextEditingController();

  final AuthService _authService = AuthService();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: AppTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter an email to reset password.....",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CustomTextFormField(
                    controller: email,
                    validator: (value) {
                      return LoginRegEmailValidation().validateEmail(
                        email.text,
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: CustomButton(
                      color: Colors.indigo,
                      width: 180,
                      child: Text("Send"),
                      onpress: () async {
                        var validated = formKey.currentState!.validate();
                        if (validated) {
                          _authService.forgotPass(email.text, context);
                        }
                        return;
                      },
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
