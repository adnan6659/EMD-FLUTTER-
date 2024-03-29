import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class smmodal2 extends StatefulWidget {
  const smmodal2({Key? key}) : super(key: key);

  @override
  _smmodal2State createState() => _smmodal2State();
}

class _smmodal2State extends State<smmodal2> {
  List<Map<String, dynamic>> _responseData = [];

  // Define your base URL
  final String baseUrl = 'http://warals1.ddns.net:8047/';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetching data from the API
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      final userId = prefs.getInt('user_id');

      final response = await http.post(
        Uri.parse('http://arizshad-002-site18.atempurl.com/api/StateMandatedDetails'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken!,
        },
        body: jsonEncode({'RegistrationId': userId, 'LicenseId': 1, 'FinId': '1'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _responseData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Handle errors here
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: Text('Topic')),
                    DataColumn(label: Text('Credit Hour')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Certificate')),
                    DataColumn(label: Text('Receipt')),
                  ],
                  rows: _responseData.map<DataRow>((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(item['Topic'] ?? '')),
                        DataCell(Text(item['CreditHr'] ?? '')),
                        DataCell(Text(item['Date'] ?? '')),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              _viewDocument(item['Certificate']);
                            },
                            child: Text('View'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              _viewDocument(item['Recipt']);
                            },
                            child: Text('View'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewDocument(String? relativeUrl) {
    if (relativeUrl != null && relativeUrl.isNotEmpty) {
      // Construct the complete URL by directly using the relative URL
      String completeUrl = baseUrl + relativeUrl.replaceAll('~', '');

      print('Viewing document at: $completeUrl');
      launch(completeUrl);
    } else {
      print('Invalid URL');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: smmodal2(),
  ));
}
