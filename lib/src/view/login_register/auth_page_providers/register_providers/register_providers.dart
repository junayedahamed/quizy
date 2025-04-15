import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizy/src/view/login_register/auth_page_providers/login_page_provider.dart';

// Import your provider file if needed

class AppProviders {
  static List<BlocProvider> providers = [
    BlocProvider<LoginPageProvider>(create: (_) => LoginPageProvider()),
  ];
}
