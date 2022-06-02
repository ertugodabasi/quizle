class StreamGameFinished {
  final String userName;

  StreamGameFinished(this.userName);

  factory StreamGameFinished.fromData(dynamic data) {
    final username = data['username'];
    return StreamGameFinished(username);
  }
}
