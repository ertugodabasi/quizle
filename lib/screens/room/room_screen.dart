import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/stream_socket_provider.dart';
import '../../providers/quiz_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import '../quiz/question_widget.dart';

class RoomScreen extends StatefulWidget {
  final String roomCode;
  final String userName;
  final bool isCreator;
  const RoomScreen(this.roomCode, this.userName, this.isCreator, {Key? key})
      : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with WidgetsBindingObserver {
  late final QuizProvider qp;

  @override
  void initState() {
    qp = QuizProvider(widget.userName);
    if (widget.isCreator) {
      qp.isHost = true;
    } else {
      qp.isHost = false;
    }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final mps = Provider.of<MultiplayerSocket>(context);
    if (mps.isConnected) {
      if (widget.isCreator) {
        mps.createRoom(widget.userName, widget.roomCode);
      } else {
        mps.joinRoom(widget.userName, widget.roomCode);
      }
      mps.errorResponse.listen((event) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(event.title),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('Tamam'))
                ],
              );
            });
      });

      mps.gameInfoResponse.listen((event) {});

      mps.gameStatusResponse.listen((event) {
        qp.startPlay(event.rightAnswerCount, event.difficulty, widget.userName);
      });

      mps.userResponse.listen((event) {
        qp.updateUsers(event.streamUsers);
      });

      mps.gameFinishedResponse.listen((event) {
        qp.finisPlay(event.userName);
      });

      mps.notificationResponse.listen((notif) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(notif.title)));
      });
      mps.scoreResponse.listen(
        (score) {
          qp.updateCompAnswerCount(score.right);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SvgPicture.asset('assets/bg.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          SafeArea(
            child: mps.isConnected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ChangeNotifierProvider.value(
                        value: qp,
                        builder: (context, child) {
                          return Consumer<QuizProvider>(
                            builder: ((context, qp, child) {
                              return Column(
                                children: [
                                  if (qp.gameState == GameState.playing)
                                    Text('Zorluk: ${qp.difficultyLevel}'),
                                  Text('Oyuncular'),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(qp.userName),
                                        if (qp.competitiveUser != null)
                                          Text(qp.competitiveUser!),
                                      ]),
                                  quizLayout(qp, mps)
                                ],
                              );
                            }),
                          );
                        },
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget quizLayout(QuizProvider qp, MultiplayerSocket mps) {
  {
    if (qp.gameState == GameState.waiting) {
      return qp.isHost
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Soru Sayısı'),
                      NumberPicker(
                        axis: Axis.horizontal,
                        value: qp.questionCount,
                        minValue: 10,
                        maxValue: 20,
                        onChanged: (value) => qp.updateQuestionCount(value),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Zorluk Seviyesi'),
                      ),
                      NumberPicker(
                        axis: Axis.horizontal,
                        value: qp.difficultyLevel,
                        minValue: 1,
                        maxValue: 6,
                        onChanged: (value) => qp.updateDifficultyLevel(value),
                      ),
                    ],
                  ),
                ),
                if (qp.users.length == 1) Text('Rakip Bekleniyor...'),
                if (qp.users.length == 1) CircularProgressIndicator.adaptive(),
                if (qp.users.length != 1)
                  IconButton(
                    iconSize: 60,
                    onPressed: qp.users.length != 2
                        ? null
                        : () {
                            print(qp.difficultyLevel);
                            mps.gameStart(qp.difficultyLevel, qp.questionCount);
                          },
                    icon: Icon(Icons.play_arrow),
                  )
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Oda Başı'nın başlatması bekleniyor..."),
                CircularProgressIndicator.adaptive()
              ],
            );
    }
    if (qp.gameState == GameState.result) {
      return Column(
        children: [
          Text('Kazanan: ${qp.winner}'),
          IconButton(
              iconSize: 60,
              onPressed: () {
                qp.updateGameState(GameState.waiting);
              },
              icon: Icon(Icons.replay))
        ],
      );
    }
    if (qp.currentQuestion == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return QuestionWidget(qp.currentQuestion!, true,
        qp.isQuestionDelayCompleted, qp.selectedIndex);
  }
}
