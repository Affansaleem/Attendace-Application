import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/api_intigration_files/repository/LeaveType_repository.dart';
import '../repository/adminGeofencePost_repository.dart';
import 'admin_geofence_event.dart';
import 'admin_geofence_state.dart';


class AdminGeoFenceBloc extends Bloc<AdminGeoFenceEvent, AdminGeoFenceState> {
  final AdminGeoFenceRepository repository;

  AdminGeoFenceBloc(this.repository) : super(InitialState());

  @override
  Stream<AdminGeoFenceState> mapEventToState(AdminGeoFenceEvent event) async* {
    if (event is SetGeoFenceEvent) {
      yield PostingState();

      try {
        await repository.setGeoFence(event.data);
        yield PostedState();
      } catch (e) {
        yield ErrorState('Failed to post Geo-fence data: $e');
      }
    }
  }
}
