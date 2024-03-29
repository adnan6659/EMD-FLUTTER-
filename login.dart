// ignore_for_file: library_private_types_in_public_api
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

import 'dashboardui.dart';
import 'forgotpassword.dart';

final logger = Logger();

class ApiService {
  final String baseUrl;
  final Dio dio;

  ApiService(this.baseUrl) : dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<bool> signIn(BuildContext context, String username, String password, bool rememberMe) async {
    try {
      // Make the API call to sign in with provided username and password
      final response = await dio.post(
        '/Userlogin',
        data: jsonEncode({'username': username, 'password': password}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Check if the response from the API is successful (status code 200)
      if (response.statusCode == 200) {
        // Extract the response data
        final Map<String, dynamic> responseData = response.data;

        // Check if the response contains user login details
        if (responseData.containsKey('ObjLoginDetails')) {
          // Extract user details from the response
          final Map<String, dynamic> userDetails = responseData['ObjLoginDetails'];

          // Check if the login status is successful
          if (userDetails.containsKey('Status') && userDetails['Status'] == 'Login Successfully.') {
            // Extract access token, user ID, and username from the response
            final String accessToken = responseData['access_token'];
            final int registrationId = userDetails['RegistrationId'];
            final String name = userDetails['Name'];

            // Store access token, user ID, and username in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('access_token', accessToken);
            prefs.setInt('user_id', registrationId);
            prefs.setString('user_name', name);

            // Save login credentials if remember me is checked
            if (rememberMe) {
              prefs.setString('username', username);
              prefs.setString('password', password);
            } else {
              prefs.remove('username');
              prefs.remove('password');
            }

            // Log the saved data
            logger.d('Saved access token: $accessToken');
            logger.d('Saved user ID: $registrationId');
            logger.d('Saved username: $name');

            // Navigate to the dashboard page after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );

            // Return true to indicate successful sign-in
            return true;
          } else {
            // Log unexpected login status
            logger.w('Unexpected Status: ${userDetails['Status']}');
          }
        } else {
          // Log when user login details are not found in the response
          logger.w('ObjLoginDetails key not found in API response');
        }
      } else if (response.statusCode == 404) {
        // Log HTTP 404 error (Endpoint not found)
        logger.e('HTTP Error: 404 - Endpoint not found');
      } else {
        // Log other HTTP status codes
        logger.e('HTTP Error: ${response.statusCode}');
      }

      // Handle errors or unsuccessful login
      return false;
    } catch (e) {
      // Log exceptions during API call
      logger.e('Exception during API call: $e');
      return false;
    }
  }
}

// SignInScreen class
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberMe = false; // Define rememberMe here
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ApiService apiService =
  ApiService('http://arizshad-002-site18.atempurl.com/api/');

  @override
  void initState() {
    super.initState();
    _retrieveRememberMeData();
  }

  Future<void> _retrieveRememberMeData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    if (savedUsername != null && savedPassword != null) {
      setState(() {
        usernameController.text = savedUsername;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'images/stethoscope.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 330,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromRGBO(233, 236, 239, 1.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(12, 26, 33, 1.0),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'Username *',
                      labelStyle: TextStyle(fontSize: 18),
                      hintText: 'Enter Username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'Password *',
                      labelStyle: TextStyle(fontSize: 18),
                      hintText: 'Enter Password',
                    ),
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = usernameController.text;
                        String password = passwordController.text;

                        final bool signedIn = await apiService.signIn(context, username, password, rememberMe);

                        if (signedIn) {
                          // Retrieve access token from shared preferences
                          final prefs = await SharedPreferences.getInstance();
                          final accessToken = prefs.getString('access_token');

                          // Print access token to console
                          print('Access Token: $accessToken');

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign-in failed. Please check your credentials.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(12, 224, 122, 1.0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                      // Add your forgot password logic here
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Do you have an account?',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register');
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}