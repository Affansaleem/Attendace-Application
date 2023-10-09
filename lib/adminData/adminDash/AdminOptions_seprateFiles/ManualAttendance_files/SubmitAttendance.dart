import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project/api_intigration_files/models/GetActiveEmployees_model.dart';
import 'package:project/api_intigration_files/ManualPunch_apiFiles/manual_punch_bloc.dart';
import 'package:project/api_intigration_files/ManualPunch_apiFiles/manual_punch_event.dart';
import 'package:project/api_intigration_files/models/PunchData_model.dart';
import 'package:project/api_intigration_files/repository/Punch_repository.dart';

class SubmitAttendance extends StatefulWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  SubmitAttendance({required this.selectedEmployees});

  @override
  _SubmitAttendanceState createState() => _SubmitAttendanceState();
}

void _showToast(BuildContext context) {
  Fluttertoast.showToast(
    msg: 'Attendance Submitted', // Message to display
    toastLength: Toast.LENGTH_SHORT, // Duration
    gravity: ToastGravity.BOTTOM, // Position
    timeInSecForIosWeb: 1, // Time duration for iOS
    backgroundColor: Colors.green, // Background color
    textColor: Colors.white, // Text color
    fontSize: 16.0, // Font size
  );
}

class _SubmitAttendanceState extends State<SubmitAttendance> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedInTime;
  TimeOfDay? selectedOutTime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManualPunchBloc(repository: ManualPunchRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Submit Attendance'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Add Date Selection Field at the top
              Row(
                children: [
                  const Text("Select Date: "),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              // Add In-Time and Out-Time Fields
              _buildTimePicker(
                title: 'In Time',
                selectedTime: selectedInTime,
                onTimeSelected: (time) {
                  setState(() {
                    selectedInTime = time;
                  });
                },
              ),
              _buildTimePicker(
                title: 'Out Time',
                selectedTime: selectedOutTime,
                onTimeSelected: (time) {
                  setState(() {
                    selectedOutTime = time;
                  });
                },
              ),
              const SizedBox(height: 20), // Add some spacing

              // Display selected employees with remarks in a table-like format
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Emp Name')),
                    const DataColumn(label: Text('Emp Code')),
                    const DataColumn(label: Text('Remarks')),
                  ],
                  rows: widget.selectedEmployees.map((employee) {
                    return DataRow(
                      cells: [
                        DataCell(Text(employee.empName ?? '')),
                        DataCell(Text(employee.empCode ?? '')),
                        DataCell(Text(employee.remarks ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20), // Add some spacing

              // Add a button for submitting attendance for In Time
              // Inside the onPressed callback for submitting attendance
              ElevatedButton(
                onPressed: () {
                  final List<PunchData> requestDataList = [];

                  // Loop through selected employees to create separate entries for each
                  for (final employee in widget.selectedEmployees) {
                    // Format the selected date and time
                    final formattedDate =
                        DateFormat("yyyy-MM-dd").format(selectedDate);
                    final formattedInTime = selectedInTime != null
                        ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedInTime!.hour,
                            selectedInTime!.minute,
                          ))
                        : '2023-10-10T09:00:00';

                    final formattedOutTime = selectedOutTime != null
                        ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedOutTime!.hour,
                            selectedOutTime!.minute,
                          ))
                        : '2023-10-10T10:00:00';

                    // Create a separate PunchData object for In Time
                    final inTime = PunchData(
                      cardNo: employee.empCode ?? '',
                      punchDatetime: formattedInTime,
                      pDay: "N",
                      isManual: "Y",
                      payCode: "1999",
                      machineNo: "1",
                      datetime1: formattedOutTime,
                      viewInfo: 0,
                      showData: 0,
                      remark: employee.remarks ?? '',
                    );

                    // Create a separate PunchData object for Out Time
                    final outTime = PunchData(
                      cardNo: employee.empCode ?? '',
                      punchDatetime: formattedOutTime,
                      pDay: "N",
                      isManual: "Y",
                      payCode: "1999",
                      machineNo: "1",
                      datetime1: formattedInTime,
                      viewInfo: 0,
                      showData: 0,
                      remark: employee.remarks ?? '',
                    );

                    // Add both In Time and Out Time entries to the list
                    requestDataList.add(inTime);
                    requestDataList.add(outTime);
                  }

                  // Dispatch the ManualPunchSubmitEvent to trigger the submission logic
                  context.read<ManualPunchBloc>().add(
                        ManualPunchSubmitEvent(
                          requestDataList: requestDataList,
                        ),
                      );
                  _showToast(context);
                },
                child: const Text('Submit Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget _buildTimePicker({
    required String title,
    TimeOfDay? selectedTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return Row(
      children: [
        Text("$title: "),
        TextButton(
          onPressed: () => _selectTime(context, selectedTime, onTimeSelected),
          child: Text(
            selectedTime != null
                ? selectedTime.format(context)
                : 'Select $title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      onTimeSelected(pickedTime);
    }
  }
}
