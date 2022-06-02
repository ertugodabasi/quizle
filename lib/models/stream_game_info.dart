class StreamGameInfo {
  final int rightAnswerCount;
  final int difficulty;

  StreamGameInfo(this.rightAnswerCount, this.difficulty);

  factory StreamGameInfo.fromData(dynamic data) {
    final rac = data['rightAnswerCount'];
    final diff = data['difficulty'];
    return StreamGameInfo(rac, diff);
  }
}
