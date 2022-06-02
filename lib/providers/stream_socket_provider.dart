import 'package:flutter/material.dart';
import '../models/stream_user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import '../models/stream_notification.dart';
import '../models/stream_score.dart';
import '../models/stream_error.dart';
import '../models/stream_game_info.dart';
import '../models/stream_game_finished.dart';
import '../models/available_room_model.dart';
import 'package:rxdart/rxdart.dart';
import '../apis/quiz_api.dart';
import '../env_constants.dart';

class MultiplayerSocket with ChangeNotifier {
  bool isConnected = false;
  IO.Socket socket = IO.io(
    SOCKET_URL,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  var _userResponse = BehaviorSubject<StreamUsers>();
  var _scoreResponse = BehaviorSubject<StreamScore>();
  var _notificationResponse = BehaviorSubject<StreamNotification>();
  var _errorResponse = BehaviorSubject<StreamError>();
  var _gameStatusResponse = BehaviorSubject<StreamGameInfo>();
  var _gameInfoResponse = BehaviorSubject<StreamGameInfo>();
  var _gameFinishedResponse = BehaviorSubject<StreamGameFinished>();
  var userName = '';

  Stream<StreamScore> get scoreResponse =>
      _scoreResponse.stream.asBroadcastStream();

  Stream<StreamUsers> get userResponse =>
      _userResponse.stream.asBroadcastStream();

  Stream<StreamNotification> get notificationResponse =>
      _notificationResponse.stream.asBroadcastStream();

  Stream<StreamError> get errorResponse =>
      _errorResponse.stream.asBroadcastStream();

  Stream<StreamGameInfo> get gameStatusResponse =>
      _gameStatusResponse.stream.asBroadcastStream();

  Stream<StreamGameInfo> get gameInfoResponse =>
      _gameInfoResponse.stream.asBroadcastStream();

  Stream<StreamGameFinished> get gameFinishedResponse =>
      _gameFinishedResponse.stream.asBroadcastStream();

  void sendInstantScore(int correctAnswerCount, int wrongAnswerCount) {
    if (socket.connected) {
      socket.emit('instant-score',
          {'right': correctAnswerCount, 'wrong': wrongAnswerCount});
    } else {}
  }

  void finishGame() {
    if (socket.connected) {
      socket.emit('game-finish', {'username': userName});
    } else {}
  }

  void leaveRoom() {
    if (socket.connected) {
      socket.emit('leave-channel');
    } else {}
  }

  void gameStart(int difficulty, int rightAnswerCount) {
    if (socket.connected) {
      socket.emit('game-start', [
        {'difficulty': difficulty, 'rightAnswerCount': rightAnswerCount}
      ]);
    } else {}
  }

  void gameInfo(int difficulty, int rightAnswerCount) {
    if (socket.connected) {
      socket.emit('game-info', [
        {'difficulty': difficulty, 'rightAnswerCount': rightAnswerCount}
      ]);
    } else {}
  }

  void createRoom(String userName, String roomCode) {
    this.userName = userName;
    if (socket.connected) {
      socket.emit('create-room', [userName, roomCode]);
    } else {}
  }

  void joinRoom(String userName, String roomCode) {
    this.userName = userName;
    if (socket.connected) {
      socket.emit('join-room', [userName, roomCode]);
    } else {}
  }

  Future<AvailableRoom> findAvailableRoom() async {
    final data = await QuizApi.getAvailableRoom(3);
    final room = AvailableRoom.fromMap(data);
    return room;
  }

  Future<void> clean() async {
    socket.dispose();
    socket.destroy();
    socket.close();
    socket.disconnect();
    isConnected = false;
    _scoreResponse.close();
    _notificationResponse.close();
    _userResponse.close();
    _errorResponse.close();
    _gameStatusResponse.close();
    _gameInfoResponse.close();
    _gameFinishedResponse.close();
  }

  void freshStart() {
    _userResponse = BehaviorSubject<StreamUsers>();
    _scoreResponse = BehaviorSubject<StreamScore>();
    _notificationResponse = BehaviorSubject<StreamNotification>();
    _errorResponse = BehaviorSubject<StreamError>();
    _gameStatusResponse = BehaviorSubject<StreamGameInfo>();
    _gameInfoResponse = BehaviorSubject<StreamGameInfo>();
    _gameFinishedResponse = BehaviorSubject<StreamGameFinished>();
    socket = IO.io(
      'https://quiz-it-api.herokuapp.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    connectAndListen();
  }

  void connectAndListen() {
    socket.connect();

    socket.onConnect((_) {
      isConnected = true;
      notifyListeners();
    });

    socket.on('users', (data) {
      _userResponse.sink.add(StreamUsers.fromData(data));
    });

    socket.on('notification', (data) {
      _notificationResponse.sink.add(StreamNotification.fromData(data));
    });
    socket.on('score', (data) {
      _scoreResponse.sink.add(StreamScore.fromData(data));
    });
    socket.on('errors', (data) {
      _errorResponse.sink.add(StreamError.fromData(data));
    });
    socket.on('game-status', (data) {
      _gameStatusResponse.add(StreamGameInfo.fromData(data));
    });
    socket.on('game-info-changed', (data) {
      _gameInfoResponse.add(StreamGameInfo.fromData(data));
    });
    socket.on('game-finished', (data) {
      _gameFinishedResponse.add(StreamGameFinished.fromData(data));
    });
    socket.onDisconnect((_) {
      isConnected = false;
      notifyListeners();
    });
  }
}
