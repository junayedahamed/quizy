import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRegEmailValidation extends Cubit<int> {
  LoginRegEmailValidation() : super(0);
  validateEmail(String email) {
    RegExp regx = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.length < 9) {
      return "enter a correct email";
    } else {
      if (regx.hasMatch(email)) {
        return null;
      } else {
        return "this email is not valid";
      }
    }
  }

  passValidation(String pass) {
    if (pass.length < 5) {
      return "password must be more than 5 character";
    } else {
      return null;
    }
  }

  passValidationReg(String pass, String confPass) {
    if (pass == confPass) {
      if (pass.length < 5) {
        return "password must be more than 5 character";
      } else {
        return null;
      }
    } else {
      return 'Those password are not same';
    }
  }
}
