import 'package:equatable/equatable.dart';
import 'package:project/api_intigration_files/models/adminGeofenceModel.dart';

abstract class AdminGeoFenceEvent extends Equatable {
  const AdminGeoFenceEvent();

  @override
  List<Object> get props => [];
}

class SetGeoFenceEvent extends AdminGeoFenceEvent {
  final List<AdminGeoFenceModel> data;

  SetGeoFenceEvent(this.data);

  @override
  List<Object> get props => [data];
}
