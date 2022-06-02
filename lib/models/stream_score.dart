class StreamScore {
  final String user;
  final int right;
  final int wrong;

  StreamScore(this.user, this.right, this.wrong);

  factory StreamScore.fromData(dynamic data) {
    final user = data['user'];
    final right = data['right'];
    final wrong = data['wrong'];
    return StreamScore(user, right, wrong);
  }
}
