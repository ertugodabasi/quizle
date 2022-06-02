import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/stream_socket_provider.dart';
import 'screens/welcome/welcome_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final mps = MultiplayerSocket();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mps),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quizle',
        theme: ThemeData.dark(),
        home: const WelcomeScreen(),
      ),
    );
  }
}
