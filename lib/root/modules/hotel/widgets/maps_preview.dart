import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';

class MapsPreview extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String hotelName;

  const MapsPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.hotelName,
  });

  Future<void> _openNativeMap() async {
    final url = Uri.parse('https://maps.google.com/?q=$latitude,$longitude');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch map');
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(latitude, longitude);

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CustomColors.borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  // We disable rotation to keep it simple, but allow pan and zoom.
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.themirza009.majestic_rooms',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // "Open in Maps" Button
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton.extended(
                heroTag: 'maps_preview_btn_${hotelName.replaceAll(" ", "_")}',
                onPressed: _openNativeMap,
                backgroundColor: CustomColors.surfaceWhite,
                icon: const Icon(Icons.map_outlined, color: CustomColors.brandRed),
                label: const Text(
                  'Open in Maps',
                  style: TextStyle(
                    color: CustomColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
