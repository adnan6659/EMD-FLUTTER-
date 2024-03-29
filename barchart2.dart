import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart'; // Importing app colors from a custom resource file
import 'package:fl_chart/fl_chart.dart'; // Importing FL Chart library
import 'package:flutter/material.dart'; // Importing Flutter material UI library

class BarChartSample2 extends StatefulWidget {
  // Defining a stateful widget for the bar chart
  BarChartSample2({super.key});

  final Color barBackgroundColor = AppColors.contentColorBlue
      .withOpacity(0.7); // Background color for the bars
  final Color barColor =
      AppColors.contentColorGreen; // Default color for the bars
  final Color touchedBarColor = AppColors.contentColorGreen
      .withOpacity(0.7); // Color for the touched bars

  @override
  State<StatefulWidget> createState() =>
      BarChartSample2State(); // Creating the state for the widget
}

class BarChartSample2State extends State<BarChartSample2> {
  // State class for the bar chart widget
  final Duration animDuration =
  const Duration(milliseconds: 300); // Animation duration for the chart
  int touchedIndex = -5; // Index of the touched bar

  // Initialize variables with default values
  double totalHours = 0.0;
  double totalHoursDone = 0.0;
  double stateMandatedHours = 0.0;
  double stateMandatedHoursDone = 0.0;
  double amaCat1Hours = 0.0;
  double amaCat1HoursDone = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'http://arizshad-002-site18.atempurl.com/api/DashboardCustom';
    final String? accessToken = await _getAccessToken();
    final int? userId = await _getUserId();

    if (accessToken == null || userId == null) {
      // Handle case where access token or user ID is null
      return;
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': accessToken,
    };

    final Map<String, dynamic> requestBody = {
      "FinId": 1,
      "RegistrationId": userId,
      "LicenceId": 1,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> responseData =
      data.isNotEmpty ? data.first : {};

      setState(() {
        // *Fix:* Removed as int casting, keeping values as doubles
        totalHours = responseData['TotalHr']?.toDouble() ?? 0.0;
        totalHoursDone = responseData['TotalHrDone']?.toDouble() ?? 0.0;
        stateMandatedHours =
            responseData['StateMandatedHrs']?.toDouble() ?? 0.0; // No casting
        stateMandatedHoursDone =
            responseData['StateMandatedHrsDone']?.toDouble() ??
                0.0; // No casting
        amaCat1Hours =
            responseData['AMACat1Hr']?.toDouble() ?? 0.0; // No casting
        amaCat1HoursDone =
            responseData['AMACat1HrDone']?.toDouble() ?? 0.0; // No casting
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            color: Colors.white10,
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                            _buildButton(Colors.blue), // Blue button
                            const SizedBox(
                                height:
                                12), // Space between button and bar chart
                            const Text(
                              'CME HRS REQUIRED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            _buildButton(
                                Colors.lightGreenAccent), // Green button
                            const SizedBox(
                                height:
                                12), // Space between button and bar chart
                            const Text(
                              'CME HRS TAKEN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BarChart(
                          mainBarData(), // Displaying main data
                          swapAnimationDuration:
                          animDuration, // Setting animation duration
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Function to create BarChartGroupData objects
  BarChartGroupData makeGroupData(
      int x,
      double y1,
      double y2, {
        bool isTouched = false,
        double width = 15,
      }) {
    Color blueColor = Colors.lightBlueAccent;
    Color greenColor = Colors.greenAccent;

    switch (x) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      default:
// Default label
        break;
    }

    // Additional bars rising from x-axis
    List<BarChartRodData> barRods = [
      // Blue bar
      BarChartRodData(
        fromY: 0,
        toY: y1,
        color: blueColor,
        width: width,
      ),
      // Green bar
      BarChartRodData(
        fromY: 0,
        toY: y2,
        color: greenColor,
        width: width,
      ),
    ];

    return BarChartGroupData(
      x: x,
      barRods: barRods,
    );
  }

  // Function to generate BarChartGroupData objects for each group
  List<BarChartGroupData> showingGroups() {
    // Check if the variables are initialized
    if (totalHours != null &&
        totalHoursDone != null &&
        stateMandatedHours != null &&
        stateMandatedHoursDone != null &&
        amaCat1Hours != null &&
        amaCat1HoursDone != null) {
      return [
        makeGroupData(0, totalHours, totalHoursDone),
        makeGroupData(1, amaCat1Hours, amaCat1HoursDone),
        makeGroupData(2, stateMandatedHours, stateMandatedHoursDone),
      ];
    } else {
      // Return an empty list if variables are not initialized
      return [];
    }
  }

  // Function to create the main bar chart data
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String label;
            switch (groupIndex) {
              case 0:
                label = rodIndex == 0 ? 'TotalHr' : 'TotalHr Done';
                break;
              case 1:
                label = rodIndex == 0 ? 'AMA CAT-1' : 'AMA CAT-1 Done';
                break;
              case 2:
                label = rodIndex == 0 ? 'State Mandate' : 'State Mandate Done';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$label\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: rod.toY.toDouble().toString(),
                  style: TextStyle(
                    color: widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = 0;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
      ),

      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(), // Setting bar groups
      gridData: const FlGridData(show: false), // Grid data for the chart
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 11
    );
    late Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Total', style: style),
              Text(' Hr', style: style),
            ],
          ),
        );
        break;
      case 1:
        text = const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('AMA', style: style),
              Text(' CAT-1', style: style),
            ],
          ),
        );
        break;
      case 2:
        text = const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('State', style: style),
              Text(' Mandated', style: style),
            ],
          ),
        );
        break;
      default:
        text = const Text('', style: style); // Setting default title
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: text,
    );
  }

  Widget _buildButton(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}