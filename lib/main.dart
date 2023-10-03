import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/api_intigration_files/repository/LeaveHistory_repository.dart';
import 'package:project/api_intigration_files/repository/emp_leave_request_repository.dart';
import 'package:project/api_intigration_files/repository/emp_post_leave_request_repository.dart';
import 'package:project/api_intigration_files/repository/emp_profile_repository.dart';
import 'package:project/app_startUp.dart';
import 'api_intigration_files/api_integration_files/api_intigration_bloc.dart';
import 'api_intigration_files/repository/emp_attendance_status_repository.dart';
import 'api_intigration_files/repository/user_repository.dart';
import 'bloc_internet/internet_bloc.dart';
import 'api_intigration_files/repository/admin_repository.dart';

// main.dart

// ... (imports)

void main() {
  Fluttertoast.showToast;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
