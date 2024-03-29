import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LicenseManagementScreen extends StatefulWidget {
  const LicenseManagementScreen({Key? key}) : super(key: key);

  @override
  _LicenseManagementScreenState createState() =>
      _LicenseManagementScreenState();
}

class _LicenseManagementScreenState extends State<LicenseManagementScreen> {
  late List<Map<String, dynamic>> licenseData;
  bool isLoading = true; // Add a loading indicator
  late int userId; // User ID
  late String userName; // Username

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Retrieve user data when the screen initializes
    fetchLicenseData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
      userName = prefs.getString('user_name') ?? '';
    });
  }

  Future<void> fetchLicenseData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final url = Uri.parse(
        'http://arizshad-002-site18.atempurl.com/api/LicenseDetails');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '$accessToken',
    };
    final body = jsonEncode({'Createdby': userId}); // Use userId

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          licenseData = responseData.cast<Map<String, dynamic>>();
          isLoading = false; // Data fetched, set loading to false
        });
        print('Fetched License Data: $licenseData'); // Logging fetched data
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      drawer: myDrawer,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              if (isLoading) // Show a loading indicator while fetching data
                Center(child: CircularProgressIndicator()),
              if (!isLoading && licenseData != null) // Only build table when data is fetched
                Column(
                  children: [
                    const SizedBox(height: 90),
                    Table(
                      defaultColumnWidth: const FlexColumnWidth(1.0),
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      border: const TableBorder(
                        horizontalInside: BorderSide.none,
                        verticalInside: BorderSide.none,
                      ),
                      columnWidths: const {
                        5: FlexColumnWidth(2.0),
                        1: FlexColumnWidth(1.5),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xFF006FFD)),
                          children: [
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'S.No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'License Name',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Total CME Hrs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'AMA Cat I Hrs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'AMA Cat II Hrs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'State Mandatory',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final data in licenseData)
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['LicennseId'].toString(),
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['LicenseName'] ?? '',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['TotalHr']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['MandatoryHr']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data['NonMandatoryHr']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      data['Topic'] ?? '',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return const YourModalWidget();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Row(
                      children: [
                        Text('Add new'),
                        Icon(Icons.add_circle),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YourModalWidget extends StatefulWidget {
  const YourModalWidget({Key? key}) : super(key: key);

  @override
  _YourModalWidgetState createState() => _YourModalWidgetState();
}

class _YourModalWidgetState extends State<YourModalWidget> {
  String? selectedOption;
  List<Map<String, dynamic>> licenses = [];
  late int userId; // User ID

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Retrieve user data when the modal initializes
    _fetchLicenses();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
    });
  }

  Future<void> _fetchLicenses() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final url = Uri.parse('http://arizshad-002-site18.atempurl.com/api/FetchLicenseName');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '$accessToken',
    };
    final body = jsonEncode({
      'Createdby': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body) as List<dynamic>;
      setState(() {
        licenses = List<Map<String, dynamic>>.from(responseData);
      });
    } catch (error) {
      print('Error fetching licenses: $error');
      // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'License : ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedOption,
                  items: licenses.map((license) {
                    return DropdownMenuItem<String>(
                      value: license['LicenseName'] as String,
                      child: Text(license['LicenseName'] as String),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  hint: const Text('Select an option'),
                  isExpanded: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Close the modal
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final accessToken = prefs.getString('access_token');
                        final url = Uri.parse('http://arizshad-002-site18.atempurl.com/api/InsertLicense');
                        final headers = {
                          'Content-Type': 'application/json',
                          'Authorization': '$accessToken',
                        };
                        final selectedLicense = licenses.firstWhere(
                                (license) => license['LicenseName'] == selectedOption);
                        final body = jsonEncode({
                          'Createdby': userId,
                          'LicenceId': selectedLicense['LicenseId']
                        });

                        try {
                          final response = await http.post(url, headers: headers, body: body);
                          final responseData = json.decode(response.body);
                          // Check response status and show appropriate dialog
                          if (response.statusCode == 200) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(responseData['Status']),
                                  content: Text(responseData['Msg']),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            throw Exception('Failed to add license: ${response.statusCode}');
                          }
                        } catch (error) {
                          print('Error adding license: $error');
                          // Show error dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Failed to add license.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Add License'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
