import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPageProvider extends Cubit<bool> {
  LoginPageProvider() : super(true);
  // bool _current = true;
  // get changeval => _current;
  toggle() {
    emit(!state);
  }

  toggle2() {
    emit(!state);
  }
}

// class LoginPageProvider extends Cubit<Map<String, bool>> {
//   LoginPageProvider() : super({'toggle1': true, 'toggle2': false});

//   void toggle1() {
//     emit({...state, 'toggle1': !state['toggle1']!});
//   }

//   void toggle2() {
//     emit({...state, 'toggle2': !state['toggle2']!});
//   }

//   bool get isToggle1 => state['toggle1']!;
//   bool get isToggle2 => state['toggle2']!;
// }
