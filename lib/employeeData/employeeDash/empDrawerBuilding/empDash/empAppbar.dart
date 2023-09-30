import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../api_intigration_files/api_integration_files/api_intigration_bloc.dart';
import 'package:project/api_intigration_files/models/user_model.dart';
import '../../../../api_intigration_files/repository/user_repository.dart';

class EmpAppBar extends StatelessWidget {
  final VoidCallback openDrawer;

  const EmpAppBar({
    Key? key,
    required this.openDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ApiIntigrationBloc(
          RepositoryProvider.of<UserRepository>(context),
        )..add(ApiLoadingEvent());
      },
      child: BlocBuilder<ApiIntigrationBloc, ApiIntigrationState>(
        builder: (context, state) {
          if (state is ApiLoadedState) {
            List<Employee> userList = state.users;
            final employee = userList.isNotEmpty ? userList[0] : null;

            return AppBar(
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars),
                color: Colors.white,
                onPressed: openDrawer,
              ),
              backgroundColor: const Color(0xFFE26142),
              elevation: 0,
              title: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "EMP-ID: ${employee!.empCode.toString()}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ApiLoadingState) {
            // Loading state, display a loading indicator
            return AppBar(
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars),
                color: Colors.white,
                onPressed: openDrawer,
              ),
              backgroundColor: const Color(0xFFE26142),
              elevation: 0,
              title: const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 55.0), // Add right padding
                  child: SizedBox(
                      height: 5,
                      width: 5,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      )), // Loading indicator
                ),
              ),
            );
          } else if (state is ApiErrorState) {
            // Handle error state, display an error message
            return AppBar(
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars),
                color: Colors.white,
                onPressed: openDrawer,
              ),
              backgroundColor: const Color(0xFFE26142),
              elevation: 0,
              title: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "Error: ${state.message}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return AppBar(
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars),
                color: Colors.white,
                onPressed: openDrawer,
              ),
              backgroundColor: const Color(0xFFE26142),
              elevation: 0,
              title: const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "Default UI",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
