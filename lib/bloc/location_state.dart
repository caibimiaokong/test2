part of 'location_bloc.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final LatLng location;
  final String mapType;

  const MapState({
    this.status = MapStatus.initial,
    this.location = const LatLng(30, 114),
    this.mapType = '',
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? location,
    String? mapType,
  }) {
    return MapState(
      status: status ?? this.status,
      location: location ?? this.location,
      mapType: mapType ?? this.mapType,
    );
  }

  @override
  List<Object?> get props => [status, location, mapType];
}
