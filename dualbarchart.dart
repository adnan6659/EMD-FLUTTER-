// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class BarChartSample2 extends StatefulWidget {
//   const BarChartSample2({super.key});
//
//   @override
//   _DualBarChartState createState() => _DualBarChartState();
// }
//
// class _DualBarChartState extends State<BarChartSample2> {
//   final double width = 7;
//   late List<BarChartGroupData> rawBarGroups;
//   late List<BarChartGroupData> showingBarGroups;
//   int touchedGroupIndex = -1;
//
//   _DualBarChartState() {
//     final barGroup1 = makeGroupData(0, 5, 12);
//     final barGroup2 = makeGroupData(1, 16, 12);
//     final barGroup3 = makeGroupData(2, 18, 5);
//
//     final items = [
//       barGroup1,
//       barGroup2,
//       barGroup3,
//     ];
//
//     rawBarGroups = items;
//     showingBarGroups = rawBarGroups;
//   }
//
//   get avgColor => null;
//
//   get leftBarColor => null;
//
//   get rightBarColor => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Column(
//                   children: [
//                     _buildButton(Colors.blue),
//                     SizedBox(height: 4),
//                     Text(
//                       'CME HRS REQUIRED',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.blueGrey, fontSize: 14),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     _buildButton(Colors.green),
//                     SizedBox(height: 4),
//                     Text(
//                       'CME HRS TAKEN',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.blueGrey, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: BarChart(
//                 BarChartData(
//                   maxY: 120,
//                   barTouchData: BarTouchData(
//                     touchTooltipData: BarTouchTooltipData(
//                       tooltipBgColor: Colors.grey,
//                       getTooltipItem: (a, b, c, d) => null,
//                     ),
//                     touchCallback: (FlTouchEvent event, response) {
//                       if (response == null || response.spot == null) {
//                         setState(() {
//                           touchedGroupIndex = -1;
//                           showingBarGroups = List.of(rawBarGroups);
//                         });
//                         return;
//                       }
//
//                       touchedGroupIndex = response.spot!.touchedBarGroupIndex;
//
//                       setState(() {
//                         if (!event.isInterestedForInteractions) {
//                           touchedGroupIndex = -1;
//                           showingBarGroups = List.of(rawBarGroups);
//                           return;
//                         }
//                         showingBarGroups = List.of(rawBarGroups);
//                         if (touchedGroupIndex != -1) {
//                           var sum = 0.0;
//                           for (final rod
//                           in showingBarGroups[touchedGroupIndex].barRods) {
//                             sum += rod.toY;
//                           }
//                           final avg = sum /
//                               showingBarGroups[touchedGroupIndex]
//                                   .barRods
//                                   .length;
//
//                           showingBarGroups[touchedGroupIndex] =
//                               showingBarGroups[touchedGroupIndex].copyWith(
//                                 barRods: showingBarGroups[touchedGroupIndex]
//                                     .barRods
//                                     .map((rod) {
//                                   return rod.copyWith(
//                                       toY: avg, color: avgColor);
//                                 }).toList(),
//                               );
//                         }
//                       });
//                     },
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: bottomTitles,
//                         reservedSize: 42,
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 28,
//                         interval: 1,
//                         getTitlesWidget: leftTitles,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   barGroups: showingBarGroups,
//                   gridData: const FlGridData(show: false),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget leftTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff7589a2),
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//
//     String text;
//     if (value == 0) {
//       text = '0';
//     } else if (value == 30) {
//       text = '30';
//     } else if (value == 60) {
//       text = '60';
//     } else if (value == 90) {
//       text = '90';
//     } else if (value == 120) {
//       text = '120';
//     } else {
//       return Container();
//     }
//
//     return RotatedBox(
//       quarterTurns: 3, // Rotate the text vertically
//       child: Text(
//         text,
//         style: style,
//       ),
//     );
//   }
//
//   Widget bottomTitles(double value, TitleMeta meta) {
//     final titles = ['Total Hr', 'AMA CAT 1', 'State Mandated'];
//
//     if (value >= 0 && value < titles.length) {
//       final Widget text = Text(
//         titles[value.toInt()],
//         style: const TextStyle(
//           color: Color(0xff7589a2),
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//       );
//
//       return SideTitleWidget(
//         axisSide: meta.axisSide,
//         space: 16, //margin top
//         child: text,
//       );
//     } else {
//       return Container(); // Return an empty container if index is out of range
//     }
//   }
//
//   BarChartGroupData makeGroupData(int x, double y1, double y2) {
//     return BarChartGroupData(
//       barsSpace: 4,
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y1,
//           color: leftBarColor,
//           width: width,
//         ),
//         BarChartRodData(
//           toY: y2,
//           color: rightBarColor,
//           width: width,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildButton(Color color) {
//     return Container(
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
// }
