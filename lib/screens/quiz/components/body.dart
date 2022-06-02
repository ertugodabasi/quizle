import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizle/constants.dart';
import '../../room/components/progress_bar.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SvgPicture.asset(
        'assets/bg.svg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: kTextFieldFillColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 3, color: kBorderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 1),
                    Text('Ertus2'),
                    Spacer(flex: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '😇',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: kPrimaryGradient, shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        child: Text('VS'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '👹',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Spacer(flex: 4),
                    Text('Erdos2'),
                    Spacer(flex: 1)
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(child: ProgressBar(3)),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child: ProgressBar(3)),
                ],
              )
            ],
          ),
        ),
      )
    ]);
  }
}
