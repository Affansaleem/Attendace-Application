import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/api_intigration_files/models/GetActiveEmployees_model.dart';

import '../../../../api_intigration_files/ManualPunch_apiFiles/manual_punch_bloc.dart';
import '../../../../api_intigration_files/ManualPunch_apiFiles/manual_punch_event.dart';
import '../../../../api_intigration_files/models/PunchData_model.dart';
import '../../../../api_intigration_files/repository/Punch_repository.dart';

class SubmitAttendance extends StatefulWidget {
  final List<GetActiveEmpModel> selectedEmployees;

  SubmitAttendance({required this.selectedEmployees});

  @override
  _SubmitAttendanceState createState() => _SubmitAttendanceState();
}

class _SubmitAttendanceState extends State<SubmitAttendance> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManualPunchBloc(
          repository: ManualPunchRepository()), // Provide your repository
      child: Scaffold(
        appBar: AppBar(
          title: Text('Submit Attendance'),
        ),
        body: Column(
          children: <Widget>[
            // Display selected employees
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedEmployees.length,
                itemBuilder: (context, index) {
                  final employee = widget.selectedEmployees[index];
                  return ListTile(
                    title: Text(employee.empName ?? ''),
                    subtitle: Text(employee.empCode ?? ''),
                    // Add more fields as needed
                  );
                },
              ),
            ),
            // Add a button for submitting attendance
            ElevatedButton(
              onPressed: () {
                // Construct the requestData with hardcoded values
                final requestData = [
                  PunchData(
                    cardNo: "00001999",
                    punchDatetime: "2023-10-10T09:00:00",
                    pDay: "N",
                    isManual: "Y",
                    payCode: "1999",
                    machineNo: "1",
                    datetime1: "2023-10-10T09:00:00",
                    viewInfo: 0,
                    showData: 0,
                    remark: "test",
                  ),
                  // Add more PunchData objects if needed
                ];

// Convert the list of PunchData objects to a list of maps

// Dispatch the ManualPunchSubmitEvent to trigger the submission logic
                print("Before dispatching ManualPunchSubmitEvent");
                context.read<ManualPunchBloc>().add(
                  ManualPunchSubmitEvent(
                    requestDataList: requestData,
                  ),
                );
                print("After dispatching ManualPunchSubmitEvent");
              },
              child: Text('Submit Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
