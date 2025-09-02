class Line {
  final int id;
  final String number;

  Line({required this.id, required this.number});

  factory Line.fromMap(Map<String, dynamic> map) {
    return Line(id: map['id'], number: map['number']);
  }
}
