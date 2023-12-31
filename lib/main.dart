import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/adminData/adminDash/AdminOptions_seprateFiles/ManualAttendance_files/ManualMarkAttendance.dart';
import 'package:project/adminData/adminDash/AdminOptions_seprateFiles/ManualAttendance_files/SubmitAttendance.dart';
import 'package:project/api_intigration_files/GetActiveEmployee_apiFiles/get_active_employee_bloc.dart';
import 'package:project/api_intigration_files/LeaveType_apiFiles/leave_type_bloc.dart';
import 'package:project/api_intigration_files/ManualPunch_apiFiles/manual_punch_bloc.dart';
import 'package:project/api_intigration_files/MonthlyReports_apiFiles/monthly_reports_bloc.dart';
import 'package:project/api_intigration_files/repository/EmpEditProfile_repository.dart';
import 'package:project/api_intigration_files/repository/GetActiveEmployee_repository.dart';
import 'package:project/api_intigration_files/repository/LeaveHistory_repository.dart';
import 'package:project/api_intigration_files/repository/LeaveRequest_repository.dart';
import 'package:project/api_intigration_files/repository/LeaveType_repository.dart';
import 'package:project/api_intigration_files/repository/MonthlyReports_repository.dart';
import 'package:project/api_intigration_files/repository/Punch_repository.dart';
import 'package:project/api_intigration_files/repository/emp_leave_request_repository.dart';
import 'package:project/api_intigration_files/repository/emp_post_leave_request_repository.dart';
import 'package:project/api_intigration_files/repository/emp_profile_repository.dart';
import 'package:project/app_startUp.dart';
import 'adminData/adminDash/AdminOptions_seprateFiles/AdminReports_files/LeaveSubmissionPage.dart';
import 'adminData/adminDash/adminDrawerPages/adminMap/adminMapdisplay.dart';
import 'api_intigration_files/EmpEditProfile_apiFiles/emp_edit_profile_bloc.dart';
import 'api_intigration_files/GeoFence_apiFiles/geo_fence_bloc.dart';
import 'api_intigration_files/LeaveRequest_apiFiles/leave_request_bloc.dart';
import 'api_intigration_files/LeaveSubmission_apiFiles/leave_submission_bloc.dart';
import 'api_intigration_files/UnApprovedLeaveRequest_apiFiles/un_approved_leave_request_bloc.dart';
import 'api_intigration_files/adminGeofenceApiFiles/admin_geofence_bloc.dart';
import 'api_intigration_files/api_integration_files/api_intigration_bloc.dart';
import 'api_intigration_files/emp_profilr_api_files/emp_profile_api_bloc.dart';
import 'api_intigration_files/repository/GeoFence_repository.dart';
import 'api_intigration_files/repository/LeaveSubmission_repository.dart';
import 'api_intigration_files/repository/UnApprovedLeaveRequest_repository.dart';
import 'api_intigration_files/repository/adminGeofencePost_repository.dart';
import 'api_intigration_files/repository/emp_attendance_status_repository.dart';
import 'api_intigration_files/repository/user_repository.dart';
import 'bloc_internet/internet_bloc.dart';
import 'api_intigration_files/repository/admin_repository.dart';
import 'employeeData/employeeDash/emp_home_seprate_files/ReportsPage_seprateFiles/Monthly_reports.dart';

// main.dart

// ... (imports)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<AdminRepository>(
          create: (_) => AdminRepository(),
        ),
        RepositoryProvider<EmpAttendanceRepository>(
          create: (_) => EmpAttendanceRepository(),
        ),
        RepositoryProvider<EmpProfileRepository>(
          create: (_) => EmpProfileRepository(),
        ),
        RepositoryProvider<EmpLeaveRepository>(
          create: (_) => EmpLeaveRepository(),
        ),
        RepositoryProvider<SubmissionRepository>(
          create: (_) => SubmissionRepository(),
        ),
        RepositoryProvider<LeaveHistoryRepository>(
          create: (_) => LeaveHistoryRepository(),
        ),
        RepositoryProvider<EmpEditProfileRepository>(
          create: (_) => EmpEditProfileRepository(),
        ),
        RepositoryProvider<GeoFenceRepository>(
          create: (_) => GeoFenceRepository(),
        ),
        RepositoryProvider<GetActiveEmpRepository>(
          create: (_) => GetActiveEmpRepository(),
        ),
        RepositoryProvider<ManualPunchRepository>(
          create: (_) => ManualPunchRepository(),
        ),
        RepositoryProvider<AdminGeoFenceRepository>(
          create: (_) => AdminGeoFenceRepository(),
        ),

        // Add other repository providers if needed
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (BuildContext context) {
              return InternetBloc();
            },
          ),
          BlocProvider<ApiIntigrationBloc>(
            create: (BuildContext context) {
              return ApiIntigrationBloc(UserRepository());
            },
          ),
          BlocProvider<EmpProfileApiBloc>(
            create: (context) => EmpProfileApiBloc(
              RepositoryProvider.of<EmpProfileRepository>(
                  context), // Provide the repository
            ),
          ),
          BlocProvider<EmpEditProfileBloc>(
            create: (BuildContext context) {
              return EmpEditProfileBloc(
                empEditProfileRepository: EmpEditProfileRepository(),
              );
            },
          ),
          BlocProvider<GeoFenceBloc>(
            create: (BuildContext context) {
              return GeoFenceBloc(
                geoFenceRepository: GeoFenceRepository(),
              );
            },
          ),
          BlocProvider<MonthlyReportsBloc>(
            create: (context) =>
                MonthlyReportsBloc(repository: MonthlyReportsRepository()),
          ),
          BlocProvider(
            create: (context) => GetEmployeeBloc(GetActiveEmpRepository()),
            child: ManualMarkAttendance(),
          ),
          BlocProvider<ManualPunchBloc>(
            create: (BuildContext context) {
              return ManualPunchBloc(repository: ManualPunchRepository());
            },
          ),
          BlocProvider(
            create: (context) =>
                LeaveRequestBloc(repository: LeaveRepository()),
            child: LeaveSubmissionPage(
              selectedEmployees: [],
            ),
          ),
          BlocProvider<UnapprovedLeaveRequestBloc>(
            create: (BuildContext context) => UnapprovedLeaveRequestBloc(
                repository: UnApprovedLeaveRepository()),
          ),
          BlocProvider<LeaveTypeBloc>(
            create: (BuildContext context) =>
                LeaveTypeBloc(repository: LeaveTypeRepository()),
          ),
          BlocProvider<AdminGeoFenceBloc>(
            create: (BuildContext context) =>
                AdminGeoFenceBloc(AdminGeoFenceRepository()),
          ),
          BlocProvider(
            create: (context) => LeaveSubmissionBloc(
              repository: LeaveSubmissionRepository(),
            ),
            child: LeaveSubmissionPage(
              selectedEmployees: [],
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: AppStartup(),
        ),
      ),
    );
  }
}
