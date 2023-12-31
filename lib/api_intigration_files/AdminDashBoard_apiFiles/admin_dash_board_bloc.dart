import 'dart:async';
import 'package:bloc/bloc.dart';

import '../repository/AdminDashBoard_repository.dart';
import 'admin_dash_board_event.dart';
import 'admin_dash_board_state.dart';


class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardRepository repository;

  AdminDashboardBloc({required this.repository}) : super(AdminDashboardState());

  @override
  Stream<AdminDashboardState> mapEventToState(AdminDashboardEvent event) async* {
    if (event is FetchDashboardData) {
      yield state.copyWith(isLoading: true, error: null);

      try {
        final dashboardData = await repository.fetchDashboardData(event.corporateId, event.date);
        yield state.copyWith(isLoading: false, dashboardData: dashboardData);
      } catch (e) {
        yield state.copyWith(isLoading: false, error: 'Failed to fetch data');
      }
    }
  }
}
