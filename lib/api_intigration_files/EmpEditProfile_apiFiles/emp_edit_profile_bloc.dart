import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/EmpEditProfile_model.dart';
import '../repository/EmpEditProfile_repository.dart';

part 'emp_edit_profile_event.dart';
part 'emp_edit_profile_state.dart';

class EmpEditProfileBloc
    extends Bloc<EmpEditProfileEvent, EmpEditProfileState> {
  final EmpEditProfileRepository empEditProfileRepository;

  EmpEditProfileBloc({required this.empEditProfileRepository})
      : super(InitialState()) {
    on<Create>((event, emit) async* {
      yield EmpEditProfileLoading();

      try {
        final empEditProfileModel = event.empEditProfileModel;
        await empEditProfileRepository.postData(empEditProfileModel);

        yield EmpEditProfileSuccess();
      } catch (e) {
        yield EmpEditProfileError(e.toString());
      }
    });

    on<SubmitEmpEditProfileData>((event, emit) async {
      try {
        final empEditProfileModel = event.empEditProfileModel;

        // Call the repository method to post data
        await empEditProfileRepository.postData(empEditProfileModel);

        emit(EmpEditProfileSuccess());
      } catch (e) {
        emit(EmpEditProfileError(e.toString()));
      }
    });
  }

  }
