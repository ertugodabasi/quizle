import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizle/constants.dart';
import 'components/custom_text_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/stream_socket_provider.dart';
import '../room/room_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final roomCodeController = TextEditingController();
  final userNameController = TextEditingController();
  String selectedEmoji = '🦁';

  @override
  Widget build(BuildContext context) {
    final mps = Provider.of<MultiplayerSocket>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset('assets/bg.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          SafeArea(
            child: LayoutBuilder(
              builder: ((context, constraints) {
                final containerHeight = constraints.maxHeight;
                return Container(
                  height: constraints.maxHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Haydi, Quiz'le!",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.white),
                        ),
                        const Text('Oda ve kullanıcı bilgilerini aşağı girin.'),
                        SizedBox(height: containerHeight * 0.05),
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedEmoji,
                                style: TextStyle(
                                  fontSize: 70,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) {
                                        return Container(
                                          color: kTextFieldFillColor,
                                          height: 300,
                                          child: SafeArea(
                                            child: EmojiPicker(
                                                config: Config(
                                                    categoryIcons:
                                                        CategoryIcons(),
                                                    bgColor:
                                                        kTextFieldFillColor,
                                                    initCategory:
                                                        Category.ANIMALS,
                                                    showRecentsTab: false),
                                                onEmojiSelected: (cat, emoji) {
                                                  setState(() {
                                                    selectedEmoji = emoji.emoji;
                                                  });
                                                }),
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  'Değiştir',
                                ),
                              )
                            ],
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: containerHeight * 0.03),
                        CustomTextField(
                          hintText: 'ör: ertus2',
                          labelText: 'Kullanıcı Adı',
                          controller: userNameController,
                        ),
                        SizedBox(height: containerHeight * 0.03),
                        CustomTextField(
                          hintText: 'ör: kafa1500',
                          labelText: 'Oda Kodu',
                          controller: roomCodeController,
                        ),
                        SizedBox(height: containerHeight * 0.03),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                          decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  print(roomCodeController.text);
                                  mps.freshStart();
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: ((context) => RoomScreen(
                                              roomCodeController.text,
                                              userNameController.text +
                                                  selectedEmoji,
                                              false)),
                                        ),
                                      )
                                      .then((value) => mps.clean());
                                },
                                child: Text("Oda'ya Gir"),
                                color: kTextFieldFillColor,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  mps.freshStart();
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: ((context) => RoomScreen(
                                              roomCodeController.text,
                                              userNameController.text +
                                                  selectedEmoji,
                                              true)),
                                        ),
                                      )
                                      .then((value) => mps.clean());
                                },
                                child: Text("Oda Oluştur"),
                                color: kTextFieldFillColor,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: containerHeight * 0.05),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                          decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(12)),
                          child: RaisedButton(
                            onPressed: () async {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) => Dialog(
                                        child: Container(
                                          height: 300,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: CircularProgressIndicator
                                                    .adaptive(),
                                              ),
                                              Text('Yükleniyor...')
                                            ],
                                          ),
                                        ),
                                      ));
                              final room = await mps.findAvailableRoom();
                              if (room.roomCode == null) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Boşta oda kalmadı. Lütfen tekrar deneyin!')));
                                return;
                              }
                              Navigator.of(context).pop();
                              mps.freshStart();
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: ((context) => RoomScreen(
                                          room.roomCode!,
                                          userNameController.text +
                                              selectedEmoji,
                                          false)),
                                    ),
                                  )
                                  .then((value) => mps.clean());
                            },
                            child: Text("Random Oda"),
                            color: kTextFieldFillColor,
                          ),
                        ),
                        SizedBox(height: containerHeight * 0.05),
                      ],
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
