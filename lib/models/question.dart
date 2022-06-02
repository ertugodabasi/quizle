class Question {
  final String question;
  final List<String> answers;
  int correctAnswerIndex;
  Question(this.question, this.answers, this.correctAnswerIndex);

  factory Question.fromMap(Map<String, dynamic> data) {
    final question = data['question'] as String;
    final answers = data['answers'].cast<String>();
    final index = data['correctAnswer'] as int;
    return Question(question, answers, index);
  }

  bool checkIfCorrect(String answer) {
    final correctAnswer = answers[correctAnswerIndex];
    return answer == correctAnswer;
  }
}
