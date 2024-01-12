import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:equatable/equatable.dart';

import 'package:test2/repository/repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRespository _mapRespository;

  MapBloc({required MapRespository mapRespository})
      : _mapRespository = mapRespository,
        super(const MapState()) {
    on<LocationRequested>((event, emit) {
      _onLocationRequested;
    });
    on<ChangeMapType>((event, emit) {
      _onChangeMapType(event, emit);
    });
  }

  Future _onLocationRequested() async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      final location = await _mapRespository.getCurrentLocation();
      debugPrint('location: $location');
      emit(state.copyWith(
        status: MapStatus.loaded,
        location: LatLng(location.latitude, location.longitude),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
      ));
    }
  }

  Future _onChangeMapType(ChangeMapType event, Emitter<MapState> emit) async {
    emit(state.copyWith(mapType: event.mapType));
  }
}
