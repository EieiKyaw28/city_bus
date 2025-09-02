import 'stop.dart';

class LineStop {
  final int lineId;
  final Stop stop;
  final int stopOrder;

  LineStop({required this.lineId, required this.stop, required this.stopOrder});

  factory LineStop.fromMap(Map<String, dynamic> map) {
    return LineStop(
      lineId: map['line_id'],
      stopOrder: map['stop_order'],
      stop: Stop.fromMap(map['stops']),
    );
  }
}
