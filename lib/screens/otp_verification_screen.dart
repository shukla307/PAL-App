// otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _verificationId;
  String? _phoneNumber;
  String? _name;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _verificationId = args?['verificationId'];
    _phoneNumber = args?['phoneNumber'];
    _name = args?['name'];
  }

  Future<void> _verifyOTP(BuildContext context) async {
    if (_otpController.text.isEmpty || _verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );

      // Sign in with credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Update user profile if name is provided
      if (_name != null && _name!.isNotEmpty) {
        await userCredential.user?.updateDisplayName(_name);
      }

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Error: ${e.message}')),
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
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to $_phoneNumber',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _verifyOTP(context),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Verify OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// //otp_verification_screen.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class OTPVerificationScreen extends StatelessWidget {
//   final TextEditingController _otpController = TextEditingController();
//
//   OTPVerificationScreen({super.key});
//
//   void _verifyOTP(BuildContext context) {
//     // Use FirebaseAuth to verify OTP.
//     // On success, navigate to the home screen.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Verify OTP")),
//       body: Column(
//         children: [
//           TextField(controller: _otpController, decoration: const InputDecoration(labelText: "Enter OTP")),
//           ElevatedButton(onPressed: () => _verifyOTP(context), child: const Text("Verify OTP")),
//         ],
//       ),
//     );
//   }
// }
