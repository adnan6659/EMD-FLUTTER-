import 'package:flutter/material.dart';

import '../modalwidgets/cat1_cmemodal.dart';
import '../modalwidgets/smmodal.dart';
import '../modalwidgets/t_cmemodal.dart';

class datatable_1 extends StatelessWidget {
  final String totalHr;
  final String totalHrDone;
  final String stateMandatedHrs;
  final String stateMandatedHrsDone;
  final String amaCat1Hr;
  final String amaCat1HrDone;

  const datatable_1({
    super.key,
    required this.totalHr,
    required this.totalHrDone,
    required this.stateMandatedHrs,
    required this.stateMandatedHrsDone,
    required this.amaCat1Hr,
    required this.amaCat1HrDone,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20, // Adjust column spacing
      columns: const [
        DataColumn(
          label: Flexible(
            child: Text(
              'CME Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Flexible(
            child: Text(
              'CME Hr Done/Required',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Flexible(
            child: Text(
              'Action',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(
            Flexible(
              child: Text('Total CME'),
            ),
          ),
          DataCell(
            Flexible(
              child: Text('$totalHrDone / $totalHr'),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                // Open the modal screen when the button is pressed
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const t_cmemodal(),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Action',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(
            Flexible(
              child: Text('AMA Cat I CME'),
            ),
          ),
          DataCell(
            Flexible(
              child: Text('$amaCat1HrDone / $amaCat1Hr'),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                // Open the modal screen when the button is pressed
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const cat1_cmemodal(),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Action',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(
            Flexible(
              child: Text('State Mandatory'),
            ),
          ),
          DataCell(
            Flexible(
              child: Text('$stateMandatedHrsDone / $stateMandatedHrs'),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                // Open the modal screen when the button is pressed
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const DataTableModal(),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Action',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}