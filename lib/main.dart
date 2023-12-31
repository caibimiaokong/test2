import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:latlong2/latlong.dart';
import 'package:test2/bloc/location_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test2/simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupertino App',
      home: BlocProvider<LocationBloc>(
        create: (context) => LocationBloc(),
        child: const Map(),
      ),
    );
  }
}

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        switch (state) {
          case LocationInitial():
            return const MyHomePage();
          case LocationLoading():
            return const Center(child: CircularProgressIndicator());
          case LocationLoaded():
            return MyHomePage(location: state.location);
          case LocationError():
            return Center(child: Text(state.message));
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.location,
  });
  final LatLng? location;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: widget.location ?? const LatLng(36, 114),
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
              point: widget.location ?? const LatLng(36.031332, 114),
              child: const Icon(
                Icons.location_on,
                size: 80.0,
                color: Colors.blue,
              ),
            ),
          ]),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
      Positioned(
          top: 150,
          right: 40,
          child: InkWell(
            onTap: () {
              context.watch<LocationBloc>().add(LocationRequested());
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
            ),
          )),
      const SearchBar(),
    ]));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FloatingSearchBarController controller =
        FloatingSearchBarController();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
        hint: 'Search...',
        controller: controller,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Colors.accents.map((color) {
                  return Container(height: 112, color: color);
                }).toList(),
              ),
            ),
          );
        });
  }
}
