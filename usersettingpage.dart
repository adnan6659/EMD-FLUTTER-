// Import necessary packages
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart'; // Importing constants.dart which contains predefined app bar and drawer widgets

var logger = Logger(); // Creating an instance of Logger from the logger package

// Widget for the user settings page
class UserSettingPage extends StatefulWidget {
  const UserSettingPage({Key? key});

  @override
  _UserSettingPageState createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String _selectedWeekday = 'Select Weekday';
  String? _selectedTime = 'Select Time';
  String? _selectedTimezone; // Instead of 'Select Timezone'

  bool isEditing = false; // Flag to track whether the user is in edit mode

  late String accessToken;
  late int userId;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch initial user data when the page loads
  }

  // Function to fetch user data from SharedPreferences
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? '';
    userId = prefs.getInt('user_id') ?? 0;
    await fetchDataFromApi(); // Fetch data from API using fetched access token and user ID
  }

  // Function to make a POST request to fetch user data from the API
  Future<void> fetchDataFromApi() async {
    try {
      if (accessToken.isNotEmpty && userId != 0) {
        final response = await http.post(
          Uri.parse('http://arizshad-002-site18.atempurl.com/api/GetUser'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
          body: jsonEncode({
            'RegistrationId': userId, // Request body with RegistrationId
          }),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            firstNameController.text =
                data[0]['FName'] ?? ''; // Populate first name field
            lastNameController.text =
                data[0]['LName'] ?? ''; // Populate last name field
            emailController.text =
                data[0]['Email'] ?? ''; // Populate email field
          });
        } else {
          logger.e('Error: ${response.statusCode}');
        }
      } else {
        logger.e('Access token or user ID not found in SharedPreferences');
      }
    } catch (error) {
      logger.e('Network error: $error');
    }
  }

  // Function to update user data via API
  Future<void> updateDataToApi() async {
    try {
      final response = await http.post(
        Uri.parse('http://arizshad-002-site18.atempurl.com/api/UpdateUser'),
        headers: {
          'Authorization': accessToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'RegistrationId': userId,
          'FirstName': firstNameController.text,
          'LastName': lastNameController.text,
          'Email': emailController.text,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Response"),
              content: Text(responseData['Message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        logger.e('Error: ${response.statusCode}');
      }
    } catch (error) {
      logger.e('Network error: $error');
    }
  }

  // Function to reset all the fields to their initial values
  void resetFields() {
    setState(() {
      firstNameController.text = ''; // Reset first name field
      lastNameController.text = ''; // Reset last name field
      emailController.text = ''; // Reset email field
      _selectedWeekday = 'Select Weekday'; // Reset selected weekday
      _selectedTime = 'Select Time'; // Reset selected time
      _selectedTimezone = null; // Reset selected timezone
    });
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
              'Profile Update:',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50.0),
            buildInputField(firstNameController),
            // Building input field for doctor
            const SizedBox(height: 5.0),
            buildInputField(lastNameController),
            // Building input field for number
            const SizedBox(height: 10.0),
            buildEmailVerificationSection(emailController),
            // Building email verification section
            const SizedBox(height: 20.0),
            buildEditButton(),
            // Building edit button
            const SizedBox(height: 20.0),
            const Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
            //divider is that black line to divide the page into two
            const SizedBox(height: 10.0),
            // Widgets below the divider
            LicenseReminderForm(
              selectedWeekday: _selectedWeekday,
              selectedTime: _selectedTime,
              selectedTimezone: _selectedTimezone,
              onWeekdayChanged: (value) {
                setState(() {
                  _selectedWeekday = value!;
                });
              },
              onTimeChanged: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
              onTimezoneChanged: (value) {
                setState(() {
                  _selectedTimezone = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Building input field widget
  Widget buildInputField(TextEditingController controller) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextField(
          controller: controller,
          enabled: isEditing,
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  // Building email verification section widget
  Widget buildEmailVerificationSection(TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width / 2,
          child: TextField(
            controller: controller,
            enabled: isEditing,
            decoration: const InputDecoration(
              labelText: 'Enter Email',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              // Simulating email verification link sending
              _sendVerificationEmail(controller.text);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text("Please enter your email address."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text(
            'VERIFY',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  // Function to simulate sending email verification link
  void _sendVerificationEmail(String email) {
    // Simulate sending the email verification link
    String verificationLink = 'http://cekeeper.com/email-verification/48';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email Verification"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Verification link has been sent to $email."),
              SizedBox(height: 10),
              Text("Click on the link to verify your email."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        if (isEditing) {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmation"),
                content: Text("Are you sure you want to make changes?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                      // Update data if confirmed
                      setState(() {
                        isEditing = !isEditing;
                        updateDataToApi(); // Call the function to update data
                      });
                    },
                    child: Text("OK"),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              );
            },
          );
        } else {
          // Toggle edit mode
          setState(() {
            isEditing = !isEditing;
          });
        }
      },
      child: Text(isEditing ? 'Save' : 'Edit'),
    );
  }
}


class LicenseReminderForm extends StatefulWidget {
  final String selectedWeekday;
  final String? selectedTime;
  final String? selectedTimezone;
  final ValueChanged<String?> onWeekdayChanged;
  final ValueChanged<String?> onTimeChanged;
  final ValueChanged<String?> onTimezoneChanged;

  const LicenseReminderForm({
    Key? key,
    required this.selectedWeekday,
    required this.selectedTime,
    required this.selectedTimezone,
    required this.onWeekdayChanged,
    required this.onTimeChanged,
    required this.onTimezoneChanged,
  }) : super(key: key);

  @override
  _LicenseReminderFormState createState() => _LicenseReminderFormState();
}

class _LicenseReminderFormState extends State<LicenseReminderForm> {
  List<String> timezoneOptions = [];
  late String accessToken;
  late int userId;
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTimezoneOptions();
    _getSharedPrefs();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  // Function to fetch timezone options from API
  Future<void> _fetchTimezoneOptions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('access_token') ?? '';
      userId = prefs.getInt('user_id') ?? 0;

      final response = await http.post(
        Uri.parse('http://arizshad-002-site18.atempurl.com/api/GetTimeZone'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          timezoneOptions =
              data.map((item) => item['TimeZone'].toString()).toList();
        });
      } else {
        throw Exception('Failed to load timezones');
      }
    } catch (e) {
      print('Error fetching timezones: $e');
    }
  }

  // Function to get access token and user ID from shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? '';
    userId = prefs.getInt('user_id') ?? 0;
  }

  // Function to save reminder details via API
  Future<void> _saveReminderDetails() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://arizshad-002-site18.atempurl.com/api/InserReminderDetils'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken',
        },
        body: jsonEncode({
          "RegistrationId": userId,
          "Days": widget.selectedWeekday,
          "Time": _timeController.text,
          "TimeZone": widget.selectedTimezone,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody == "Data Inserted Successfully.") {
          _showSavedSuccessfullyDialog();
        } else {
          throw Exception('Failed to insert data');
        }
      } else {
        throw Exception('Failed to insert data');
      }
    } catch (e) {
      print('Error saving reminder details: $e');
    }
  }

  // Function to save data after successful save dialog
  void _saveData() {
    // Implement your code to save data here
  }

  // Function to show dialog indicating successful save
  void _showSavedSuccessfullyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Time period saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveData();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to reset reminder details via API
  Future<void> _resetReminderDetails() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://arizshad-002-site18.atempurl.com/api/InserReminderDetils'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken',
        },
        body: jsonEncode({
          "RegistrationId": userId,
          "Days": "",
          "Time": "",
          "TimeZone": "",
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody == "Data Inserted Successfully.") {
          _showResetSuccessfullyDialog();
        } else {
          throw Exception('Failed to reset data');
        }
      } else {
        throw Exception('Failed to reset data');
      }
    } catch (e) {
      print('Error resetting reminder details: $e');
    }
  }

  // Function to show dialog indicating successful reset
  void _showResetSuccessfullyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Reset data saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveData();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select from the below option when you want the reminder of license expiry:',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 40.0),
          _buildTimePicker(),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _saveReminderDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _resetReminderDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Building time picker widget
  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoxWithTitle('Select Weekday:', _buildWeekdayDropdown()),
        const SizedBox(height: 15.0),
        _buildBoxWithTitle(
          'Time:',
          TextFormField(
            controller: _timeController,
            decoration: InputDecoration(
              hintText: 'Select Time',
              prefixIcon: Icon(Icons.access_time),
              contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        _buildBoxWithTitle('Select Timezone:', _buildTimezoneDropdown()),
      ],
    );
  }

  // Building dropdown widget for selecting weekday
  Widget _buildWeekdayDropdown() {
    return DropdownButtonFormField<String?>(
      value: widget.selectedWeekday,
      items: const [
        DropdownMenuItem(
          value: 'Select Weekday',
          child: Text('Select Weekday'),
        ),
        DropdownMenuItem(
          value: 'Monday',
          child: Text('Monday'),
        ),
        DropdownMenuItem(
          value: 'Tuesday',
          child: Text('Tuesday'),
        ),
        DropdownMenuItem(
          value: 'Wednesday',
          child: Text('Wednesday'),
        ),
        DropdownMenuItem(
          value: 'Thursday',
          child: Text('Thursday'),
        ),
        DropdownMenuItem(
          value: 'Friday',
          child: Text('Friday'),
        ),
        DropdownMenuItem(
          value: 'Saturday',
          child: Text('Saturday'),
        ),
        DropdownMenuItem(
          value: 'Sunday',
          child: Text('Sunday'),
        ),
      ],
      onChanged: (value) {
        widget.onWeekdayChanged(value!);
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Building dropdown widget for selecting timezone
  Widget _buildTimezoneDropdown() {
    return DropdownButtonFormField<String?>(
      value: widget.selectedTimezone,
      items: timezoneOptions
          .map(
            (timezone) => DropdownMenuItem(
          value: timezone,
          child: Text(timezone),
        ),
      )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          widget.onTimezoneChanged(value);
        }
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        border: OutlineInputBorder(),
      ),
    );
  }

  // Building box widget with title
  Widget _buildBoxWithTitle(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        child,
      ],
    );
  }
}

// Widget for the settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Using the AppBar from constants.dart
      drawer: Drawer(), // Using the Drawer from constants.dart
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LicenseReminderForm(
          selectedWeekday: 'Select Weekday',
          selectedTime: null,
          selectedTimezone: null,
          onWeekdayChanged: (value) {
            // Handle weekday change
          },
          onTimeChanged: (value) {
            // Handle time change
          },
          onTimezoneChanged: (value) {
            // Handle timezone change
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SettingsPage(),
  ));
}