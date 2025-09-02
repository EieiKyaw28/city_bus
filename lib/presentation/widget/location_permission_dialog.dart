import 'package:bus_track/constant/extension.dart';
import 'package:flutter/material.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  const LocationPermissionDialog({super.key, this.onAllow, this.onDeny});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Location and Your Weather",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "This app requires access to your location to provide accurate weather information.",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          10.vGap,
          const Text(
            "If you deny permission, you should manually enter your location.",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
          ),
          20.vGap,
          InkWell(
            onTap: () {
              onAllow!();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Allow", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          6.vGap,
        ],
      ),
    );
  }
}
