import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/stream_user_model.dart';
import '../apis/quiz_api.dart';

typedef AnswerCallBack = void Function(int correctCount, int wrongCount);

class QuizProvider with ChangeNotifier {
  final String userName;
  QuizProvider(this.userName);
  var difficultyLevel = 3;
  var questionCount = 10;
  var isHost = true;
  var answeredQuestionCount = 0;
  var falseQuestionCount = 0;
  var correctQuestionCount = 0;
  var compCorrectQuestionCount = 0;
  var gameState = GameState.waiting;
  String? competitiveUser;
  List<StreamUser> users = [];
  String winner = '';

  Question? currentQuestion;
  bool isQuestionDelayCompleted = true;
  int selectedIndex = 0;
  bool isCorrect = true;

  Future<Question> getNextQuestion(int difficultyLevel) async {
    final quizData = await QuizApi.getQuestion(difficultyLevel);
    final question = Question.fromMap(quizData);
    currentQuestion = question;
    isQuestionDelayCompleted = true;
    notifyListeners();
    return question;
  }

  void updateQuestionCount(int qCount) {
    questionCount = qCount;
    notifyListeners();
  }

  void updateUsers(List<StreamUser> streamUsers) {
    users = streamUsers;
    String? compUser;
    for (StreamUser user in users) {
      if (user.name != userName) {
        compUser = user.name;
      }
    }
    competitiveUser = compUser;
    if (streamUsers.length == 1) {
      isHost = true;
      gameState = GameState.waiting;
    }
    notifyListeners();
  }

  void updateDifficultyLevel(int diff) async {
    difficultyLevel = diff;
    notifyListeners();
  }

  void startPlay(int qc, int difficulty, String userName) {
    clearScores();
    questionCount = qc;
    difficultyLevel = difficulty;
    gameState = GameState.playing;
    getNextQuestion(difficulty);
    notifyListeners();
  }

  void finisPlay(String un) {
    winner = un;
    gameState = GameState.result;
    notifyListeners();
  }

  void updateGameState(GameState newState) {
    gameState = newState;
    notifyListeners();
  }

  void clearScores() {
    correctQuestionCount = 0;
    falseQuestionCount = 0;
    compCorrectQuestionCount = 0;
    currentQuestion = null;
  }

  void updateCompAnswerCount(int answCount) {
    if (answCount > questionCount || answCount == compCorrectQuestionCount) {
      return;
    }
    compCorrectQuestionCount = answCount;
    notifyListeners();
  }

  bool answerQuestion(
      bool isCorrect, AnswerCallBack answerCallBack, int index) {
    answeredQuestionCount += 1;
    if (isCorrect) {
      correctQuestionCount += 1;
    } else {
      falseQuestionCount += 1;
    }
    answerCallBack(correctQuestionCount, falseQuestionCount);
    isQuestionDelayCompleted = false;
    selectedIndex = index;
    this.isCorrect = isCorrect;
    notifyListeners();
    getNextQuestion(difficultyLevel);
    return correctQuestionCount == questionCount;
  }
}

enum GameState { waiting, playing, result }
