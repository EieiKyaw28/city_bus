import 'dart:developer';

import 'package:bus_track/presentation/widget/location_permission_dialog.dart';
import 'package:bus_track/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/stop.dart';
import 'models/line.dart';
import 'models/line_stop.dart';

class BusScreen extends StatefulWidget {
  @override
  _BusScreenState createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<Line> lines = [];
  Line? selectedLine;
  Stop? startStop;
  Stop? endStop;
  List<LineStop> betweenStops = [];

  double? lat;
  double? lon;

  @override
  void initState() {
    super.initState();
    loadLines();
    getCurrentLatLon(context);
  }

  void getCurrentLatLon(BuildContext context) async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final position = await LocationService().getCurrentLocation(context);
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return LocationPermissionDialog(
            onAllow: () async {
              final position = await LocationService().getCurrentLocation(context);
              setState(() {
                lat = position.latitude;
                lon = position.longitude;
              });
              if (lat != null && lon != null) {
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            onDeny: () {},
          );
        },
      );
    }

    log("Location: ($lat, $lon)");
  }

  // Fetch all lines
  void loadLines() async {
    final res = await Supabase.instance.client.from('lines').select();
    final data = res as List; // res is already the data
    lines = data.map((e) => Line.fromMap(e)).toList();
    setState(() {});
  }

  void loadBetweenStops() async {
    if (selectedLine != null && startStop != null && endStop != null) {
      // 1. Get stop_order for start
      final startOrderRes = await Supabase.instance.client.from('line_stops').select('stop_order').eq('line_id', selectedLine!.id).eq('stop_id', startStop!.id).single();

      final startOrder = startOrderRes['stop_order'];

      // 2. Get stop_order for end
      final endOrderRes = await Supabase.instance.client.from('line_stops').select('stop_order').eq('line_id', selectedLine!.id).eq('stop_id', endStop!.id).single();

      final endOrder = endOrderRes['stop_order'];

      // 3. Get all stops in between
      final res = await Supabase.instance.client.from('line_stops').select('stop_order, stops(id,name)').eq('line_id', selectedLine!.id).gte('stop_order', startOrder).lte('stop_order', endOrder).order('stop_order', ascending: true);

      final data = res as List;
      betweenStops = data.map((e) => LineStop.fromMap(e)).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Bus App')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Line Dropdown
            DropdownButton<Line>(
              hint: Text('Select Line'),
              value: selectedLine,
              items: lines.map((line) => DropdownMenuItem(value: line, child: Text(line.number))).toList(),
              onChanged: (val) {
                setState(() {
                  selectedLine = val;
                  startStop = null;
                  endStop = null;
                  betweenStops = [];
                });
              },
            ),

            // Start & End Stop Dropdowns
            if (selectedLine != null)
              FutureBuilder(
                future: Supabase.instance.client.from('line_stops').select('stop_id, stops(id,name)').eq('line_id', selectedLine!.id).order('stop_order', ascending: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Text('No stops found');
                  }

                  final stopsData = (snapshot.data as List).map((e) => Stop.fromMap(e['stops'])).toList();

                  return Column(
                    children: [
                      DropdownButton<Stop>(
                        hint: const Text('Start Stop'),
                        value: startStop,
                        items: stopsData.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                        onChanged: (val) {
                          setState(() {
                            startStop = val;
                          });
                        },
                      ),
                      DropdownButton<Stop>(
                        hint: const Text('End Stop'),
                        value: endStop,
                        items: stopsData.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                        onChanged: (val) {
                          setState(() {
                            endStop = val;
                            loadBetweenStops();
                          });
                        },
                      ),
                    ],
                  );
                },
              ),

            SizedBox(height: 20),
            Text('Stops in Between:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: betweenStops.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(betweenStops[index].stop.name), subtitle: Text('Order: ${betweenStops[index].stopOrder}'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
