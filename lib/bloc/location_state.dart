part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationLoaded extends LocationState {
  final LatLng location;
  LocationLoaded({required this.location});
}

final class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
