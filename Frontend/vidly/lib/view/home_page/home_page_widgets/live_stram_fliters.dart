import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamFilterWidget extends StatefulWidget {
  @override
  _LiveStreamFilterWidgetState createState() => _LiveStreamFilterWidgetState();
}

class _LiveStreamFilterWidgetState extends State<LiveStreamFilterWidget> {
  // Lists for event types and time ranges.
  final List<String> _eventTypes = ["live", "upcoming"];
  final List<String> _timeRanges = ['today', '3_days', '1_week'];

  // Currently selected event type and time range.
  String? _selectedEventType;
  String? _selectedTimeRange;

  @override
  void initState() {
    super.initState();
    // Set default selections.
    _selectedEventType = _eventTypes.first;
    _selectedTimeRange = _timeRanges.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adjust height as needed.
      height: 500,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            'Filter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                // Event Type Section
                Text(
                  'Select Event Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: _eventTypes.map((eventType) {
                    return RadioListTile<String>(
                      title: Text(eventType),
                      value: eventType,
                      groupValue: _selectedEventType,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedEventType = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                Divider(),

                // Time Range Section
                Text(
                  'Select Time Range',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: _timeRanges.map((timeRange) {
                    return RadioListTile<String>(
                      title: Text(timeRange),
                      value: timeRange,
                      groupValue: _selectedTimeRange,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedTimeRange = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Create a map to hold the filter selections.
              final filterSelection = {
                'selectedEventType': _selectedEventType,
                'selectedTimeRange': _selectedTimeRange,
              };

              // Return the filter selections.
              Get.back(result: filterSelection);
            },
            child: Text("Apply"),
          ),
        ],
      ),
    );
  }
}
