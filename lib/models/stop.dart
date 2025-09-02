class Stop {
  final int id;
  final String name;

  Stop({required this.id, required this.name});

  factory Stop.fromMap(Map<String, dynamic> map) {
    return Stop(id: map['id'], name: map['name']);
  }
}
