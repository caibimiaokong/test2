part of 'location_bloc.dart';

@immutable
sealed class MapEvent {}

final class LocationRequested extends MapEvent {}

final class ChangeMapType extends MapEvent {
  final String mapType;
  ChangeMapType(this.mapType);
}
