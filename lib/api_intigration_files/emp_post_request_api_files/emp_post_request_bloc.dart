import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project/api_intigration_files/models/submission_model.dart';

import '../repository/emp_post_leave_request_repository.dart'; // Import your SubmissionModel

part 'emp_post_request_event.dart';
part 'emp_post_request_state.dart';

class EmpPostRequestBloc extends Bloc<EmpPostRequestEvent, EmpPostRequestState> {
  final SubmissionRepository submissionRepository;

  EmpPostRequestBloc({required this.submissionRepository})
      : super(InitialState()) {
    on<Create>((event, emit) async {
      emit(SubmissionLoading());
      try {
        final submissionModel = SubmissionModel(
          employeeId: event.employeeId,
          fromDate: event.fromDate,
          toDate: event.toDate,
          reason: event.reason,
          leaveId: event.leaveId,
          leaveDuration: event.leaveDuration,
          status: event.status,
          applicationDate: event.applicationDate,
          remark: event.remark,
        );

        await submissionRepository.postData(submissionModel);

        emit(SubmissionSuccess());
      } catch (e) {
        emit(SubmissionError(e.toString()));
      }
    });
  }
}
