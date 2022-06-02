import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizle/constants.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/stream_socket_provider.dart';
import '../../widgets/question_header.dart';
import '../../models/question.dart';
import '../room/components/progress_bar.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final bool isCorrect;
  final bool isQuestionDelayCompleted;
  final int selectedIndex;
  const QuestionWidget(this.question, this.isCorrect,
      this.isQuestionDelayCompleted, this.selectedIndex,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuizProvider>(context, listen: false);
    final mps = Provider.of<MultiplayerSocket>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: ProgressBar(qp.correctQuestionCount)),
              Expanded(child: ProgressBar(qp.compCorrectQuestionCount)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          QuestionHeader(
            question.question,
            isCorrect: isQuestionDelayCompleted ? null : isCorrect,
          ),
          ...List.generate(
            question.answers.length,
            (index) {
              final answer = question.answers[index];
              final isCorrectAnswer = index == question.correctAnswerIndex;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: isQuestionDelayCompleted
                      ? kTextFieldFillColor.withOpacity(0.5)
                      : index == question.correctAnswerIndex
                          ? Colors.green
                          : (selectedIndex == index
                              ? Colors.red
                              : kTextFieldFillColor.withOpacity(0.5)),
                  child: ListTile(
                    leading: const Icon(Icons.arrow_right),
                    onTap: !isQuestionDelayCompleted
                        ? null
                        : () {
                            final isFinished = qp.answerQuestion(
                                isCorrectAnswer, mps.sendInstantScore, index);
                            if (isFinished) {
                              mps.finishGame();
                            }
                          },
                    title: Text(
                      answer,
                    ),
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
