import 'package:flutter/material.dart';
import 'components/body.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Geç',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: const Body(),
    );
  }
}
