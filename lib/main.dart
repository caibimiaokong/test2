import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test2/bloc/location_bloc.dart';
import 'package:test2/repository/repository.dart';
import 'package:test2/widget/maptype_bottom_sheet.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupertino App',
      home: Scaffold(
        body: RepositoryProvider(
          create: (context) => MapRespository(),
          child: BlocProvider<MapBloc>(
            create: (context) =>
                MapBloc(mapRespository: context.read<MapRespository>())
                  ..add(LocationRequested()),
            child: const MainPage(),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        switch (state.status) {
          case MapStatus.initial:
            return const Center(child: Text('initial'));
          case MapStatus.loading:
            return const Center(child: Text('loading'));
          case MapStatus.loaded:
            return MapScreen(
              location: state.location,
              mapType: state.mapType,
            );
          case MapStatus.error:
            return const Center(child: Text('something went wrong'));
        }
      },
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location,
    required this.mapType,
  });
  final LatLng? location;
  final String mapType;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: widget.location ?? const LatLng(30, 114),
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
              width: 20,
              height: 20,
              point: widget.location ?? const LatLng(30, 114),
              child: const Icon(
                Icons.location_on,
                size: 80.0,
                color: Colors.blue,
              ),
            ),
          ]),
        ],
      ),
      Positioned(
          top: 150,
          right: 40,
          child: InkWell(
            onTap: () {
              context.watch<MapBloc>().add(LocationRequested());
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
            ),
          )),
      Positioned(
          top: 220,
          right: 40,
          child: InkWell(
            onTap: () {
              _showBottomSheet(context);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.layers,
                color: Colors.blue,
              ),
            ),
          )),
      Center(
        child: Container(
          width: 200,
          height: 50,
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle, color: Colors.white),
          child: Center(
            child: Text(
              widget.mapType,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      )
    ]));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (_) => StationsBottomSheet(
        onStationTypeSelected: (type) {
          context.read<MapBloc>().add(ChangeMapType(type));
        },
        currentMapType: context.read<MapBloc>().state.mapType,
      ),
    );
  }
}
