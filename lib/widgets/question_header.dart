import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'package:quizle/constants.dart';

class QuestionHeader extends StatelessWidget {
  final String title;
  final bool? isCorrect;
  const QuestionHeader(this.title, {this.isCorrect, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuizProvider>(context);

    return Container(
      height: 80,
      color: kTextFieldFillColor,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${title} ?',
                style: Theme.of(context).textTheme.headline6!,
              ),
            ),
          ]),
    );
  }
}

class GameInfo extends StatelessWidget {
  const GameInfo({
    Key? key,
    required this.qp,
  }) : super(key: key);

  final QuizProvider qp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.grey,
          ),
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.all(8),
      height: 50,
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.chatQuestion,
                color: Colors.white,
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                qp.answeredQuestionCount.toString(),
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          const VerticalDivider(
            color: Colors.white,
          ),
          Row(
            children: [
              Icon(
                MdiIcons.cancel,
                color: Colors.red,
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                qp.falseQuestionCount.toString(),
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          VerticalDivider(
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(
                  MdiIcons.checkboxMarked,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  qp.correctQuestionCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
