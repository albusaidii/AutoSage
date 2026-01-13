import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GarageDetailScreen extends StatelessWidget {
  final String garageName;
  final String address;
  final String directionsUrl;
  final String phoneNumber;

  const GarageDetailScreen({
    super.key,
    required this.garageName,
    required this.address,
    required this.directionsUrl,
    required this.phoneNumber,
  });

  // =========================
  // LAUNCH GOOGLE MAPS
  // =========================
  Future<void> _launchMaps(BuildContext context) async {
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(directionsUrl)}",
    );

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open maps")),
      );
    }
  }


  // =========================
  // LAUNCH PHONE DIALER
  // =========================
  Future<void> _launchDialer(BuildContext context) async {
    final Uri telUrl = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open phone dialer"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(garageName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // =========================
          // HEADER
          // =========================
          Text(
            garageName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // =========================
          // DIRECTIONS BUTTON
          // =========================
          ElevatedButton.icon(
            onPressed: () => _launchMaps(context),
            icon: const Icon(Icons.directions_outlined),
            label: const Text('Directions'),
          ),

          const SizedBox(height: 24),

          // =========================
          // ADDRESS TILE
          // =========================
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Address'),
            subtitle: Text(address),
            onTap: () => _launchMaps(context),
          ),

          // =========================
          // PHONE NUMBER TILE
          // =========================
          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: const Text('Phone Number'),
            subtitle: Text(phoneNumber),
            onTap: () => _launchDialer(context),
          ),
        ],
      ),
    );
  }
}
