import 'package:brewstreet_app/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<String> filters = [
    "All",
    "Quiet",
    "Wi-Fi",
    "Pets",
    "A/C",
    "Friendly",
  ];

  int selected = 1;

  final CameraPosition initialCamera = const CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 14,
  );

  final Set<Marker> markers = {
    const Marker(
      markerId: MarkerId("1"),
      position: LatLng(10.7775, 106.7010),
    ),
    const Marker(
      markerId: MarkerId("2"),
      position: LatLng(10.7750, 106.6990),
    ),
    const Marker(
      markerId: MarkerId("3"),
      position: LatLng(10.7788, 106.7045),
    ),
    const Marker(
      markerId: MarkerId("4"),
      position: LatLng(10.7730, 106.7030),
    ),
  };

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xff5B4024);
    const background = Color(0xffFAF8F4);

    return Scaffold(
      backgroundColor: background,

      bottomNavigationBar: const AppBottomNavBar(
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Map",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: brown,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final isSelected = selected == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? brown
                              : const Color(0xffEFE9DD),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            filters[index],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.brown,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: GoogleMap(
                    initialCameraPosition: initialCamera,
                    markers: markers,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}