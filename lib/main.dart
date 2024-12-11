import 'package:auth/screens/medical_chart_screen.dart';
import 'package:auth/screens/admin_login_screen.dart';
import 'package:auth/screens/auth_screen.dart';
import 'package:auth/screens/home_screen.dart';
import 'package:auth/screens/medical_history_screen.dart';
import 'package:auth/screens/otp_verification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // to remove banner
      title: 'Flutter App',
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/otpVerification': (context) => const OTPVerificationScreen(),
        '/home': (context) => const HomeScreen(),
        '/medicalHistory': (context) => MedicalHistoryScreen(),
        //changes
        '/': (context) => const AuthScreen(),
        '/adminLogin': (context) => AdminLoginScreen(),
      //  '/adminDashboard': (context) => AdminDashboardScreen(),
      },
    );
  }
}

