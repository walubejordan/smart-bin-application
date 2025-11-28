import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '/config/mapbox_token.dart'; // your token file

class BinMapScreen extends StatefulWidget {
  const BinMapScreen({super.key});

  @override
  State<BinMapScreen> createState() => _BinMapScreenState();
}

class _BinMapScreenState extends State<BinMapScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  static final centralUganda = Point(coordinates: Position(32.58252, 0.347596));

  static final List<Map<String, dynamic>> dummyBins = [
    {
      'id': 'BIN001',
      'location': 'Kampala Road',
      'level': 80,
      'lat': 0.347596,
      'lng': 32.582520,
    },
    {
      'id': 'BIN002',
      'location': 'Jinja Town',
      'level': 40,
      'lat': 0.435000,
      'lng': 33.203000,
    },
    {
      'id': 'BIN003',
      'location': 'Mbale Market',
      'level': 100,
      'lat': 1.082000,
      'lng': 34.175000,
    },
  ];

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(MapBoxConfig.accessToken);
  }

  /// Convert bins into mapbox annotations
  Future<void> _addMarkers() async {
    if (mapboxMap == null) return;

    final annotations = await mapboxMap!.annotations.createPointAnnotationManager();
    pointAnnotationManager = annotations;

    for (var bin in dummyBins) {
      final level = bin['level'];

      final color = level >= 90
          ? Colors.red
          : level >= 60
              ? Colors.orange
              : Colors.green;

      final annotation = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(bin['lng'], bin['lat']),
        ),
        iconColor: color.value,
        iconSize: 1.3,
      );

      await annotations.create(annotation);
    }

    // TODO: Add tap listener for point annotations
    // Note: The listener implementation depends on the mapbox_maps_flutter API version
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Bin Map", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey.shade600),
                  hintText: "Search address or bin ID",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MapWidget(
                      cameraOptions: CameraOptions(
                        center: centralUganda,
                        zoom: 9,
                      ),
                      onMapCreated: (MapboxMap mapbox) {
                        mapboxMap = mapbox;
                        _addMarkers();
                      },
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Tap a pin to view bin details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Markers show bin status in real time",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet for bin details
  // ignore: unused_element
  void _showBinDetails(
      BuildContext context, String id, String location, int level) {
    final Color levelColor =
        level >= 90 ? Colors.red : (level >= 60 ? Colors.orange : Colors.green);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(location, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.delete_outline, color: levelColor),
                  const SizedBox(width: 8),
                  Text(
                    "Status: $level% Full",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("View Details"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Dispatch"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
