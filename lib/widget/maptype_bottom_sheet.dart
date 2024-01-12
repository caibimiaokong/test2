import 'package:flutter/material.dart';

class StationsBottomSheet extends StatefulWidget {
  final String currentMapType;
  final void Function(String) onStationTypeSelected;

  const StationsBottomSheet({
    required this.currentMapType,
    required this.onStationTypeSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<StationsBottomSheet> createState() => _StationsBottomSheetState();
}

class _StationsBottomSheetState extends State<StationsBottomSheet> {
  late String selectedMapType = widget.currentMapType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 67,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              SizedBox(width: 16),
              Text(
                'Map Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 16),
              _buildMapTypeBox(
                label: 'Normal',
              ),
              const SizedBox(width: 16),
              _buildMapTypeBox(
                label: 'Satellite',
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 34),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                widget.onStationTypeSelected(selectedMapType);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: const Text(
                  'Apply',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMapTypeBox({
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedMapType = label;
              });
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: selectedMapType == label
                    ? Border.all(
                        color: Colors.blue,
                        width: 2,
                      )
                    : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(label)),
            ),
          ),
        ],
      ),
    );
  }
}
