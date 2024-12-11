
// auth_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendOTP(BuildContext context) async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      String phoneNumber = '+91${_phoneController.text}';

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if possible (mainly on Android)
          await _auth.signInWithCredential(credential);
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification Failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen and pass necessary data
          Navigator.pushNamed(
            context,
            '/otpVerification',
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': phoneNumber,
              'name': _nameController.text,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixText: "+91 ", // Modify based on your country code
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _sendOTP(context),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Get OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
































// // auth_screen.dart
// import 'package:flutter/material.dart';
//
// class AuthScreen extends StatelessWidget {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//
//   AuthScreen({super.key});
//
//   void _sendOTP(BuildContext context) {
//     // Call FirebaseAuth to send an OTP to the entered phone number.
//     // Then navigate to OTP verification screen.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Authentication")),
//       body: Column(
//         children: [
//           TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
//           TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
//           ElevatedButton(onPressed: () => _sendOTP(context), child: const Text("Get OTP")),
//         ],
//       ),
//     );
//   }
// }
