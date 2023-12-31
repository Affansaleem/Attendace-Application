import 'dart:async';
import 'package:bloc/bloc.dart';

import '../models/Department_model.dart';
import '../repository/Department_repository.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository departmentRepository = DepartmentRepository();

  DepartmentBloc() : super(DepartmentInitial());

  @override
  Stream<DepartmentState> mapEventToState(
      DepartmentEvent event,
      ) async* {
    if (event is FetchDepartments) {
      yield DepartmentLoading();
      try {
        final List<Department> departments =
        await departmentRepository.getAllActiveDepartments(event.corporateId);
        yield DepartmentLoaded(departments);
      } catch (e) {
        yield DepartmentError(e.toString());
      }
    }
  }
}
