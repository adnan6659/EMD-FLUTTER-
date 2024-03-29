import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Import for ImageFilter
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  Future<void> _resetPassword(BuildContext context) async {
    const String apiUrl = "http://arizshad-002-site18.atempurl.com/api/ForgetPassword_Email";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'Email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset request successful
        // You can add logic here to handle the response, e.g., show a success message.
        if (kDebugMode) {
          print('Password reset request successful');
        }
      } else {
        // Handle the error, e.g., display an error message
        if (kDebugMode) {
          print('Password reset request failed');
        }
      }
    } catch (error) {
      // Handle any network or other errors
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RESET PASSWORD',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email address to reset your password.',
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Call the function to reset the password
                      _resetPassword(context);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 150),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: const Text('SEND'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement cancel logic
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 140),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('CANCEL'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showForgotPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Stack(
        children: [
          // Blurred Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent.withOpacity(0.5), // Adjust the opacity as needed
            ),
          ),
          // Forgot Password Screen
          Center(
            child: ForgotPasswordScreen(),
          ),
        ],
      );
    },
  );
}
