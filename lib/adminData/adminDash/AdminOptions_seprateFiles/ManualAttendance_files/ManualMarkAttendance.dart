import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_bloc.dart';
import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_event.dart';
import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_state.dart';
import '../../../../api_intigration_files/models/GetActiveEmployees_model.dart';
import 'SubmitAttendance.dart';

class ManualMarkAttendance extends StatefulWidget {
  @override
  _ManualMarkAttendanceState createState() => _ManualMarkAttendanceState();
}

class _ManualMarkAttendanceState extends State<ManualMarkAttendance> {
  String corporateId = '';
  List<GetActiveEmpModel> employees = [];
  List<GetActiveEmpModel> selectedEmployees = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchCorporateIdFromPrefs();
  }

  Future<void> _fetchCorporateIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCorporateId = prefs.getString('corporate_id');
    print("Stored corporate id: $storedCorporateId");
    setState(() {
      corporateId = storedCorporateId ?? '';
    });

    context.read<GetEmployeeBloc>().add(FetchEmployees(corporateId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<GetEmployeeBloc>().state;

    if (state is GetEmployeeLoaded) {
      final employees = state.employees;
      setState(() {
        this.employees = employees;
      });
      _updateSelectAll(); // Call this method to update the select all checkbox
    }
  }

  void _toggleEmployeeSelection(GetActiveEmpModel employee) {
    setState(() {
      employee.isSelected = !employee.isSelected;
      if (employee.isSelected) {
        selectedEmployees.add(employee);
      } else {
        selectedEmployees.remove(employee);
      }
      print('Employee ${employee.empName} isSelected: ${employee.isSelected}');
      print('Selected Employees: $selectedEmployees');
    });
  }

  void _updateSelectAll() {
    bool allSelected = employees.every((employee) => employee.isSelected);
    setState(() {
      selectAll = allSelected;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      print('Select All: $selectAll');

      for (var employee in employees) {
        employee.isSelected = selectAll;
      }

      // Update the selectedEmployees list to match the selected state
      if (selectAll) {
        selectedEmployees = List.from(employees);
      } else {
        selectedEmployees.clear();
      }
      print('Selected Employees: $selectedEmployees');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Mark Attendance'),
        actions: [
          Checkbox(
            value: selectAll,
            onChanged: (value) {
              _toggleSelectAll();
            },
          ),
        ],
      ),
      body: BlocBuilder<GetEmployeeBloc, GetActiveEmployeeState>(
        builder: (context, state) {
          if (state is GetEmployeeInitial) {
            return const CircularProgressIndicator();
          } else if (state is GetEmployeeLoaded) {
            final employees = state.employees;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee.empName ?? ''),
                  subtitle: Text(employee.empCode ?? ''),
                  trailing: Checkbox(
                    value: employee.isSelected,
                    onChanged: (_) {
                      _toggleEmployeeSelection(employee);
                    },
                  ),
                );
              },
            );
          } else if (state is GetEmployeeError) {
            return Text('Error: ${state.errorMessage}');
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'save_button',
        onPressed: () {
          print('Selected Employees: $selectedEmployees');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubmitAttendance(selectedEmployees: selectedEmployees),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
