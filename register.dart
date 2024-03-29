import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final Logger _logger = Logger();
  bool rememberMe = false;
  bool registrationSuccessful = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Widget _buildRegistrationStatusWidget() {
    return registrationSuccessful
        ? Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/login.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Registration Successful!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'images/login.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(); // Placeholder when registration is not successful
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/stethoscope.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 300,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromRGBO(233, 236, 239, 1.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      child: Column(
                        children: [
                          _buildInputField('First Name *', 'First Name',
                              controller: firstNameController),
                          const SizedBox(height: 10),
                          _buildInputField('Last Name *', 'Last Name',
                              controller: lastNameController),
                          const SizedBox(height: 10),
                          _buildInputField('Email *', 'Email',
                              controller: emailController),
                          const SizedBox(height: 10),
                          _buildInputField(
                              'Create Password *', 'Create Password',
                              obscureText: true,
                              controller: passwordController),
                          const SizedBox(height: 10),
                          _buildInputField(
                              'Confirm Password *', 'Confirm Password',
                              obscureText: true,
                              controller: confirmPasswordController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _registerUser();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(12, 224, 122, 1.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 19),
                        ),
                        const SizedBox(height: 0),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildRegistrationStatusWidget(), // Add this line to include the status widget
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      {bool obscureText = false, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      obscureText: obscureText,
    );
  }

  Future<void> _registerUser() async {
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // You should perform validation here before making the API request

    // Make sure passwords match
    if (password != confirmPassword) {
      // Show an error message or handle the mismatch
      return;
    }

    // Make your API request here
    final Uri uri = Uri.parse('http://warals1.ddns.net:8045/api/Registration');
    final response = await http.post(
      uri,
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    // Handle the API response
    if (response.statusCode == 200) {
      // Registration successful
      // You can navigate to another screen or show a success message
      setState(() {
        registrationSuccessful = true; // Set the flag to true
      });

      _logger.i('Registration successful!');
      _logger.i('Response body: ${response.body}');
    } else {
      // Registration failed
      // You can show an error message based on the response
      _logger.e('Registration failed: ${response.body}');
    }
  }
}
