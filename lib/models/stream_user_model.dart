class StreamUser {
  final String id;
  final String name;
  final String room;

  StreamUser(this.id, this.name, this.room);
}

class StreamUsers {
  final List<StreamUser> streamUsers;
  StreamUsers(this.streamUsers);

  factory StreamUsers.fromData(dynamic data) {
    final userList = data as List;
    final streamUserList = userList.map((user) {
      return StreamUser(user['id'], user['name'], user['room']);
    }).toList();
    return StreamUsers(streamUserList);
  }
}
