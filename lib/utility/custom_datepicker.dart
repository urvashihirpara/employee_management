import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({super.key, required this.initialDate, required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _selectPresetDate(int days) {
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: days));
    });
    widget.onDateSelected(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preset Buttons
              Row(
                children: [
                  _buildPresetButton("Today", 0),
                  SizedBox(width: 10),
                  _buildPresetButton("Next Monday", _daysUntilNext(DayOfWeek.monday)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildPresetButton("Next Tuesday", _daysUntilNext(DayOfWeek.tuesday)),
                  SizedBox(width: 10),
                  _buildPresetButton("After 1 week", 7),
                ],
              ),
              SizedBox(height: 10),
              // Calendar Widget
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: _onDaySelected,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Selected Date & Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Selected Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        DateFormat("dd MMM yyyy").format(_selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Buttons
                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.grey.shade100,elevation: 0.0),
                        child: Text('Cancel',style: TextStyle(color: Colors.blue),),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () {
                          widget.onDateSelected(_selectedDate);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue),
                        child: Text('Save',style: TextStyle(color: Colors.white),),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a preset button
  Widget _buildPresetButton(String text, int daysToAdd) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _selectPresetDate(daysToAdd),
        style: ElevatedButton.styleFrom(
          backgroundColor: daysToAdd == 0 ? Colors.blue.shade100 : Colors.blue,
          foregroundColor: daysToAdd == 0 ? Colors.black : Colors.white,
        ),
        child: Text(text),
      ),
    );
  }

  // Calculate days until the next specific weekday
  int _daysUntilNext(DayOfWeek day) {
    DateTime now = DateTime.now();
    int today = now.weekday;
    int target = day.index + 1;
    return (target - today) > 0 ? (target - today) : (target - today + 7);
  }
}

// Enum for weekdays
enum DayOfWeek { monday, tuesday }
