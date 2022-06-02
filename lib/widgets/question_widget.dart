import 'package:flutter/material.dart';
import '../models/question.dart';
import '../widgets/question_header.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/stream_socket_provider.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final VoidCallback onTap;
  final bool showAnswer;
  const QuestionWidget(this.question, this.onTap, this.showAnswer, {Key? key})
      : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool? isCorrect;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuizProvider>(context, listen: false);
    final mps = Provider.of<MultiplayerSocket>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          QuestionHeader(
            widget.question.question,
            isCorrect: isCorrect,
          ),
          ...List.generate(
            widget.question.answers.length,
            (index) {
              final answer = widget.question.answers[index];
              final isCorrectAnswer =
                  index == widget.question.correctAnswerIndex;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  tileColor: isCorrect == null
                      ? Colors.deepPurpleAccent.withOpacity(0.5)
                      : index == widget.question.correctAnswerIndex
                          ? Colors.green
                          : (selectedIndex == index
                              ? Colors.red
                              : Colors.deepPurpleAccent.withOpacity(0.5)),
                  onTap: isCorrect != null
                      ? null
                      : () {
                          setState(() {
                            this.isCorrect =
                                widget.question.checkIfCorrect(answer);
                            selectedIndex = index;
                            final isFinished = qp.answerQuestion(
                                isCorrect!, mps.sendInstantScore, 0);
                            if (isFinished) {
                              mps.finishGame();
                            }
                          });
                        },
                  title: Text(
                    answer,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
