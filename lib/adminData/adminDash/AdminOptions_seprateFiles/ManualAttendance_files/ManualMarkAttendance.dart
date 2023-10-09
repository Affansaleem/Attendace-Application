import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_bloc.dart';
import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_event.dart';
import '../../../../api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_state.dart';
import '../../../../api_intigration_files/models/Department_model.dart';
import '../../../../api_intigration_files/models/GetActiveEmployees_model.dart';
import '../../../../api_intigration_files/repository/Branch_repository.dart';
import '../../../../api_intigration_files/repository/Company_repository.dart';
import '../../../../api_intigration_files/repository/Department_repository.dart';
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
  final TextEditingController _remarksController = TextEditingController();
  String filterOption = 'Default'; // Initialize with Default
  String filterId = '';
  List<String> departmentNames = [];
  String? departmentDropdownValue;
  String searchQuery = '';
  Department? selectedDepartment;
  String? branchDropdownValue;
  List<String> branchNames = [];
  String? companyDropdownValue;
  List<String> companyNames = [];

  @override
  void initState() {
    super.initState();
    _fetchCorporateIdFromPrefs();
    _fetchDepartmentNames();
    _fetchBranchNames(); // Fetch department names when the widget initializes
    _fetchCompanyNames(); // Fetch company names when the widget initializes
    companyDropdownValue = null;
  }

  Future<void> _fetchDepartmentNames() async {
    try {
      final departments =
          await DepartmentRepository().getAllActiveDepartments(corporateId);

      // Extract department names from the departments list and filter out null values
      final departmentNames = departments
          .map((department) => department.deptName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.departmentNames = departmentNames;
      });
    } catch (e) {
      print('Error fetching department names: $e');
    }
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

  Future<void> _fetchBranchNames() async {
    try {
      final branches =
          await BranchRepository().getAllActiveBranches(corporateId);

      // Extract branch names from the branches list and filter out null values
      final branchNames = branches
          .map((branch) => branch.branchName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.branchNames = branchNames;
      });
    } catch (e) {
      print('Error fetching branch names: $e');
    }
  }

  Future<void> _fetchCompanyNames() async {
    try {
      // Replace with the actual method to fetch company names
      final companies =
          await CompanyRepository().getAllActiveCompanies(corporateId);

      // Extract company names from the companies list and filter out null values
      final companyNames = companies
          .map((company) => company.companyName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.companyNames = companyNames;
      });
    } catch (e) {
      print('Error fetching company names: $e');
    }
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

  void _showRemarksDialog(GetActiveEmpModel employee) {
    _remarksController.text = employee.remarks;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Remarks'),
          content: TextField(
            controller: _remarksController,
            decoration: const InputDecoration(
              hintText: 'Enter remarks...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the remarks when OK is pressed
                employee.remarks = _remarksController.text;
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _employeeMatchesFilter(GetActiveEmpModel employee) {
    bool departmentMatch = true;
    bool branchMatch = true;
    bool companyMatch = true;

    // Check if a department is selected and match it with the employee's department
    if (departmentDropdownValue != null) {
      departmentMatch = employee.deptNames == departmentDropdownValue;
    }

    // Check if a branch is selected and match it with the employee's branch
    if (branchDropdownValue != null) {
      branchMatch = employee.branchNames == branchDropdownValue;
    }

    // Check if a company is selected and match it with the employee's company
    if (companyDropdownValue != null) {
      companyMatch = employee.companyNames == companyDropdownValue;
    }

    // Check if the search query matches employee's name or code
    bool searchMatch = searchQuery.isEmpty ||
        (employee.empName?.toLowerCase().contains(searchQuery.toLowerCase()) ??
            false) ||
        (employee.empCode?.toLowerCase().contains(searchQuery.toLowerCase()) ??
            false);

    // Return true if all conditions are met, otherwise, return false
    return departmentMatch && branchMatch && companyMatch && searchMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Mark Attendance'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Department Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton<String>(
                        value: departmentDropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            departmentDropdownValue = newValue!;
                          });
                        },
                        items: departmentNames.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                // Branch Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Branch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton<String>(
                        value: branchDropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            branchDropdownValue = newValue!;
                          });
                        },
                        items: branchNames.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                // Company Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton<String>(
                        value: companyDropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            companyDropdownValue = newValue!;
                          });
                        },
                        items: companyNames.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<GetEmployeeBloc, GetActiveEmployeeState>(
              builder: (context, state) {
                if (state is GetEmployeeInitial) {
                  return const CircularProgressIndicator();
                } else if (state is GetEmployeeLoaded) {
                  final employees = state.employees;
                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      // Check if the employee matches the selected filter criteria
                      if (_employeeMatchesFilter(employee)) {
                        return ListTile(
                          title: Text(employee.empName ?? ''),
                          subtitle: Text(employee.empCode ?? ''),
                          trailing: Checkbox(
                            value: employee.isSelected,
                            onChanged: (_) {
                              _toggleEmployeeSelection(employee);
                            },
                          ),
                          onTap: () {
                            _showRemarksDialog(employee);
                          },
                        );
                      } else {
                        return const SizedBox.shrink(); // Hide if not matching
                      }
                    },
                  );
                } else if (state is GetEmployeeError) {
                  return Text('Error: ${state.errorMessage}');
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'save_button',
        onPressed: () {
          print('Selected Employees: $selectedEmployees');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitAttendance(
                selectedEmployees: selectedEmployees,
              ),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
