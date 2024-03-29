// import 'package:e_m_d/screens/login.dart';
// import 'package:e_m_d/screens/register.dart';
// import 'package:e_m_d/screens/updatepw.dart';
// import 'package:e_m_d/screens/usersettingpage.dart';
import 'package:flutter/material.dart';
import 'package:login_dms/screens/login.dart';
import 'package:login_dms/screens/register.dart';
import 'package:login_dms/screens/updatepw.dart';
import 'package:login_dms/screens/usersettingpage.dart';
import 'screens./dashboardui.dart';
import 'screens./licensescreen.dart';
import 'modalwidgets/cat1_cmemodal.dart';
import 'modalwidgets/cat1_cmemodal2.dart';
import 'modalwidgets/smmodal.dart';
import 'modalwidgets/smmodal2.dart';
import 'modalwidgets/t_cmemodal.dart';
import 'modalwidgets/t_cmemodal2.dart';




void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const SignInScreen(),
      'register': (context) => const MyRegister(),
      'dashboard': (context) => const Dashboard(),
      '/license': (context) => const LicenseManagementScreen(),
      '/updatepassword': (context) => const UpdatePasswordScreen(),
      '/sign_out': (context) => const SignInScreen(), // Define a route for the sign-out page
      '/user_settings': (context) => const UserSettingPage(), // Define route for UserSettingPage
      '/modal': (context) => const DataTableModal(), //  the route for smmodal
      '/smmodal2': (context) => const smmodal2(), //  the route for smmodal
      '/t_cmemodal': (context) => const t_cmemodal(), // Named route for the modal screen
      '/t_cmemodal2': (context) => const t_cmemodal2(), // Route for the t_cmemodal2 widget
      '/cat1_cmemodal': (context) => const cat1_cmemodal(), // Named route for the cat1_cmemodal screen
      '/cat1_cmemodal2': (context) => const cat1_cmemodal2(), // Named route for the cat1_cmemodal screen


    },
  ));
}