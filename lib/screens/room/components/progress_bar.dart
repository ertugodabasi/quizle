import 'package:flutter/material.dart';
import 'package:quizle/constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/quiz_provider.dart';

class ProgressBar extends StatelessWidget {
  final int correctAnswerCount;
  const ProgressBar(
    this.correctAnswerCount, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuizProvider>(context);
    final completeRatio = correctAnswerCount / qp.questionCount;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 35,
      decoration: BoxDecoration(
        color: kTextFieldFillColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 3, color: kBorderColor),
      ),
      child: Stack(
        children: [
          // LayoutBuilder provide us the available space for the conatiner
          // constraints.maxWidth needed for our animation
          LayoutBuilder(
            builder: (context, constraints) => Container(
              // from 0 to 1 it takes 60s
              width: constraints.maxWidth * completeRatio,
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  FittedBox(
                    child: Text.rich(
                      TextSpan(
                        text: correctAnswerCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: kSecondaryColor),
                        children: [
                          TextSpan(
                            text: "/${qp.questionCount.toString()}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: kSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
