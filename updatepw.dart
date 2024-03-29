import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final userId = prefs.getInt('user_id');
    return {'access_token': accessToken, 'user_id': userId};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar, // Using the AppBar from constants.dart
      drawer: myDrawer, // Using the Drawer from constants.dart
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: _isObscureOldPassword,
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscureOldPassword = !_isObscureOldPassword;
                                });
                              },
                              icon: Icon(
                                _isObscureOldPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Enter your old password.',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText: _isObscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscureNewPassword = !_isObscureNewPassword;
                            });
                          },
                          icon: Icon(
                            _isObscureNewPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isObscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword = !_isObscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _isObscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password.';
                        }
                        if (value != _newPasswordController.text) {
                          return 'New password and confirm password do not match.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final userData = await getUserData();
                        final accessToken = userData['access_token'];
                        final userId = userData['user_id'];

                        final response = await http.post(
                          Uri.parse('http://arizshad-002-site18.atempurl.com/api/UpdatePassword'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': accessToken ?? '',
                          },
                          body: jsonEncode({
                            'RegistrationId': userId, // Use the retrieved user ID here
                            'OldPassword': _oldPasswordController.text,
                            'NewPassword': _newPasswordController.text,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final responseBody = response.body;
                          if (responseBody == 'Password has been successfully updated!') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password updated successfully!')),
                            );
                            _oldPasswordController.clear();
                            _newPasswordController.clear();
                            _confirmPasswordController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update password. Please try again.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update password. Please try again.')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
