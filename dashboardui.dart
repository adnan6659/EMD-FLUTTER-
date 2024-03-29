import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../datatables/data_table1.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../datatables/data_table2.dart';
import '../utilities/barchart.dart';
import '../utilities/barchart2.dart';

final logger = Logger(); // Create an instance of the logger

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _selectedYear1 = 'Select an item';
  String _selectedYear2 = 'Select an item';
  String licenseName1 = 'Loading...'; // Name for License Data 1
  String licenseName2 = 'Loading...'; // Name for License Data 2
  var responseDataDashboard; // Variable to store response data for Dashboard
  var responseDataSecondLicense; // Variable to store response data for Second License

  @override
  void initState() {
    super.initState();
    _fetchDataFromDashboardCustom();
    _fetchSecondLicenseData();
  }

  // Function to retrieve the access token from SharedPreferences
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Function to fetch data from the initial API
  Future<void> _fetchDataFromDashboardCustom() async {
    if (responseDataDashboard == null) {
      // Check if data is not already fetched
      try {
        final String? accessToken = await _getAccessToken();
        final int? userId = await _getUserId();

        if (accessToken != null && userId != null) {
          var url = 'http://arizshad-002-site18.atempurl.com/api/DashboardCustom';
          var headers = {
            'Content-Type': 'application/json',
            'Authorization': '$accessToken',
          };
          var requestBody = {
            "FinId": 1,
            "RegistrationId": userId,
            "LicenceId": 1,
          };
          var response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody));

          if (response.statusCode == 200) {
            responseDataDashboard = jsonDecode(response.body);
            if (mounted) {
              setState(() {
                licenseName1 = responseDataDashboard[0]["LicenseName"];
              });
            }
          } else if (response.statusCode == 401) {
            logger.e('Token expired. Status Code: ${response.statusCode}');
          } else {
            logger.e('Request failed with status: ${response.statusCode}');
            logger.e('Response body: ${response.body}');
          }
        } else {
          logger.e('Access token or user ID is null.');
        }
      } catch (e) {
        logger.e('Exception occurred: $e');
      }
    }
  }

  // Function to fetch data for the second license
  Future<void> _fetchSecondLicenseData() async {
    if (responseDataSecondLicense == null) {
      try {
        final String? accessToken = await _getAccessToken();
        final int? userId = await _getUserId();

        if (accessToken != null && userId != null) {
          var url = 'http://arizshad-002-site18.atempurl.com/api/DashboardCustom';
          var headers = {
            'Content-Type': 'application/json',
            'Authorization': '$accessToken',
          };
          var requestBody = {
            "FinId": 2,
            "RegistrationId": userId,
            "LicenceId": 2,
          };
          var response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody));

          if (response.statusCode == 200) {
            responseDataSecondLicense = jsonDecode(response.body);
            if (mounted) {
              setState(() {
                if (responseDataSecondLicense != null &&
                    responseDataSecondLicense is List &&
                    responseDataSecondLicense.isNotEmpty &&
                    responseDataSecondLicense[0] is Map<String, dynamic>) {
                  licenseName2 = responseDataSecondLicense[0]["LicenseName"];
                }
              });
            }
          } else if (response.statusCode == 401) {
            logger.e('Token expired. Status Code: ${response.statusCode}');
          } else {
            logger.e('Request failed with status: ${response.statusCode}');
            logger.e('Response body: ${response.body}');
          }
        } else {
          logger.e('Access token or user ID is null.');
        }
      } catch (e) {
        logger.e('Exception occurred: $e');
      }
    }
  }

  // Function to retrieve the user ID from SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myAppBarBackgroundColor,
        title: myAppBarTitle,
        leading: myAppBarLeading,
        actions: myAppBarActions,
      ),
      drawer: myDrawer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      licenseName1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedYear1,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedYear1 = newValue!;
                          });
                        },
                        items: <String>['Select an item', '2023-24']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BarChartSample1(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: _fetchDataFromDashboardCustom(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: datatable_1(
                              totalHr: responseDataDashboard[0]['TotalHr'].toString(),
                              totalHrDone: responseDataDashboard[0]['TotalHrDone'].toString(),
                              stateMandatedHrs: responseDataDashboard[0]['StateMandatedHrs'].toString(),
                              stateMandatedHrsDone: responseDataDashboard[0]['StateMandatedHrsDone'].toString(),
                              amaCat1Hr: responseDataDashboard[0]['AMACat1Hr'].toString(),
                              amaCat1HrDone: responseDataDashboard[0]['AMACat1HrDone'].toString(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '*State Mandated should be AMA CAT I',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            licenseName2,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedYear2,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedYear2 = newValue!;
                                });
                              },
                              items: <String>['Select an item', '2023-24']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: BarChartSample2(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: _fetchSecondLicenseData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (responseDataSecondLicense != null &&
                              responseDataSecondLicense.isNotEmpty &&
                              responseDataSecondLicense[0] is Map<String, dynamic>) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Datatable2(
                                totalHr: responseDataSecondLicense[0]['TotalHr'].toString(),
                                totalHrDone: responseDataSecondLicense[0]['TotalHrDone'].toString(),
                                stateMandatedHrs: responseDataSecondLicense[0]['StateMandatedHrs'].toString(),
                                stateMandatedHrsDone: responseDataSecondLicense[0]['StateMandatedHrsDone'].toString(),
                                amaCat1Hr: responseDataSecondLicense[0]['AMACat1Hr'].toString(),
                                amaCat1HrDone: responseDataSecondLicense[0]['AMACat1HrDone'].toString(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '*State Mandated should be AMA CAT I',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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