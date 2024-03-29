import 'package:flutter/material.dart';

class Lic_exp_form extends StatefulWidget {
  final String selectedWeekday;
  final String? selectedTime;
  final String? selectedTimezone;
  final ValueChanged<String?> onWeekdayChanged;
  final ValueChanged<String?> onTimeChanged;
  final ValueChanged<String?> onTimezoneChanged;

  const Lic_exp_form({super.key,
    required this.selectedWeekday,
    required this.selectedTime,
    required this.selectedTimezone,
    required this.onWeekdayChanged,
    required this.onTimeChanged,
    required this.onTimezoneChanged,
  });

  @override
  _Lic_exp_formState createState() => _Lic_exp_formState();
}

class _Lic_exp_formState extends State<Lic_exp_form> {
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Save functionality
                },
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
                onPressed: () {
                  widget.onWeekdayChanged('Select Weekday');
                  widget.onTimeChanged('Select Time');
                  widget.onTimezoneChanged('Select Timezone');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoxWithTitle('Select Weekday:', _buildWeekdayDropdown()),
        const SizedBox(height: 15.0),
        _buildBoxWithTitle(
          'Time:',
          _buildTimeDropdown(),
        ),
        const SizedBox(height: 15.0),
        _buildBoxWithTitle('Select Timezone:', _buildTimezoneDropdown()),
      ],
    );
  }

  Widget _buildTimeDropdown() {
    List<String> hours = List.generate(24, (index) => index.toString());
    List<String> minutes = List.generate(60, (index) => index.toString());

    return Row(
      children: [
        _buildTimeUnitDropdown(
          title: 'Hours',
          values: hours,
          onChanged: (value) {
            widget.onTimeChanged(
                '$value:${widget.selectedTime?.split(":")[1] ?? '00'}');
          },
        ),
        const SizedBox(width: 10.0),
        _buildTimeUnitDropdown(
          title: 'Minutes',
          values: minutes,
          onChanged: (value) {
            widget.onTimeChanged(
                '${widget.selectedTime?.split(":")[0] ?? '00'}:$value');
          },
        ),
      ],
    );
  }

  Widget _buildTimeUnitDropdown({
    required String title,
    required List<String> values,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: values.first,
        items: values.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: title,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

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

  Widget _buildTimezoneDropdown() {
    return DropdownButtonFormField<String?>(
      value: widget.selectedTimezone ?? null,
      items: const [
        DropdownMenuItem(
          value: null,
          child: Text('Select Timezone'),
        ),
        DropdownMenuItem(
          value: 'Default',
          child: Text('Default'),
        ),
        // Add remaining timezone options ...
      ],
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
}