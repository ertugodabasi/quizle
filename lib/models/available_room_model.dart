class AvailableRoom {
  final String? roomCode;
  AvailableRoom(this.roomCode);

  factory AvailableRoom.fromMap(Map<String, dynamic> data) {
    final rc = data['results'] as String?;
    return AvailableRoom(rc);
  }

  bool get isThereRoom {
    final result = roomCode ?? false;
    return true;
  }
}
