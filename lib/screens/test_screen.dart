import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestScreen extends StatefulWidget {
  final int numberOfQuestions;

  TestScreen({required this.numberOfQuestions});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int numberOfRemaining = 0;
  int numberOfCorrect = 0;
  int correctRate = 0;

  int questionLeft = 5;
  String operator = "";
  int questionRight = 5;
  String answerString = "";

  late AudioPlayer _audioPlayer;

  bool isCalcButtonsEnabled = false; //電卓ボタンが使える
  bool isAnswerCheckButtonEnable = false; //答え合わせボタンが使えるかどうか
  bool isBackButtonEnable = false; //　戻るボタンが使えるかどうか
  bool isCorrectInCorrectImageEnable = false; //○×ボタンが使えるかどうか
  bool isEndMessageEnabled = false; //メッセージを表示するかどうか
  bool isCorrect = false; //正解かどうか
  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;
    correctRate = 0;
    numberOfRemaining = widget.numberOfQuestions;

    // 効果音の準備
    _audioPlayer = AudioPlayer();
    SetQuestion();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // スコア表示部分
                _scorePart(),
                //問題表示部分
                _questionPart(),
                //電卓ボタン部分
                _calcButtons(),
                //答え合わせ部分
                _answerCheckButton(),
                //戻る部分
                _backButton()
              ],
            ),
            // ◯×画像
            _correctIncorrectImage(),
            //テスト終了メッセージ
            _endMessage(),
          ],
        ),
      ),
    );
  }

  //スコア表示部分
  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: Table(
        children: [
          TableRow(children: [
            Center(
              child: Text(
                "残り問題数",
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            Center(
              child: Text(
                "正解数",
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            Center(
              child: Text(
                "正答率",
                style: TextStyle(fontSize: 10.0),
              ),
            )
          ]),
          TableRow(children: [
            Center(
              child: Text(
                numberOfRemaining.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Text(
                numberOfCorrect.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Center(
              child: Text(
                correctRate.toString(),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  //問題表示部分
  Widget _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionLeft.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                operator,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionRight.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "=",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                answerString,
                style: TextStyle(fontSize: 60.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //電卓ボタン部分
  Widget _calcButtons() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
        child: Table(
          children: [
            TableRow(children: [
              _calcButton("7"),
              _calcButton("8"),
              _calcButton("9"),
            ]),
            TableRow(children: [
              _calcButton("4"),
              _calcButton("5"),
              _calcButton("6"),
            ]),
            TableRow(children: [
              _calcButton("1"),
              _calcButton("2"),
              _calcButton("4"),
            ]),
            TableRow(children: [
              _calcButton("0"),
              _calcButton("-"),
              _calcButton("C"),
            ]),
          ],
        ),
      ),
    );
  }

  //数字ボタン
  Widget _calcButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown, foregroundColor: Colors.white),
        onPressed: isCalcButtonsEnabled ? () => inputAnswer(numString) : null,
        child: Text(
          numString,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  //答え合わせ部分
  Widget _answerCheckButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isCalcButtonsEnabled ? () => answerCheck() : null,
          child: Text(
            "答え合わせ",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  //戻る部分
  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isBackButtonEnable ? () => closeTestScreen() : null,
          child: Text(
            "戻る",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  // ◯×
  Widget _correctIncorrectImage() {
    if (isCorrectInCorrectImageEnable == true) {
      if (isCorrect) {
        return Center(child: Image.asset("assets/images/pic_correct.png"));
      }
      return Center(child: Image.asset("assets/images/pic_incorrect.png"));
    } else {
      return Container();
    }
  }

  // テスト終了
  Widget _endMessage() {
    if (isEndMessageEnabled) {
      return Center(
          child: Text(
        "テスト終了",
        style: TextStyle(fontSize: 70.0),
      ));
    } else {
      return Container();
    }
  }

  //問題を出す
  void SetQuestion() {
    isCalcButtonsEnabled = true;
    isAnswerCheckButtonEnable = true;
    isBackButtonEnable = false;
    isCorrectInCorrectImageEnable = false;
    isEndMessageEnabled = false;
    isCorrect = false;
    answerString = "";

    Random random = Random();
    questionLeft = random.nextInt(100) + 1; //左は0-100のランダムな数字
    questionRight = random.nextInt(100) + 1; //左は0-100のランダムな数字

    //ランダムに1か2を出す　1なら+　2なら-
    if (random.nextInt(2) + 1 == 1) {
      operator = "+";
    } else {
      operator = "-";
    }

    setState(() {});
  }

  inputAnswer(String numString) {
    setState(() {
      // Cの時空文字にする
      if (numString == "C") {
        answerString = "";
        return;
      }
      if (numString == "-") {
        if (answerString == "") answerString = "-"; //　-の時は先頭しかだめ
        return;
      }
      if (numString == "0") {
        //一文字目が0か-以外の時は0はOK
        if (answerString != "0" && answerString != "-")
          answerString = answerString + numString;
        return;
      }
      if (answerString == "0") {
        //既に0が入っている場合は新しい数字におきかわる
        answerString = numString;
        return;
      }
      answerString = answerString + numString;
    });
  }

  answerCheck() {
    if (answerString == "" || answerString == "-") {
      return;
    }

    isCalcButtonsEnabled = false;
    isAnswerCheckButtonEnable = false;
    isBackButtonEnable = false;
    isCorrectInCorrectImageEnable = true;
    isEndMessageEnabled = false;

    numberOfRemaining -= 1;

    var myAnswer = int.parse(answerString).toInt();
    var realAnswer = questionLeft + questionRight;
    if (operator == "+") {
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }

    if (myAnswer == realAnswer) {
      isCorrect = true;
      numberOfCorrect += 1;
    } else {
      isCorrect = false;
    }

    _playSound(isCorrect);
    correctRate =
        (numberOfCorrect / (widget.numberOfQuestions - numberOfRemaining) * 100)
            .toInt();
    if (numberOfRemaining == 0) {
      //問題数がないとき
      isCalcButtonsEnabled = false;
      isAnswerCheckButtonEnable = false;
      isBackButtonEnable = true;
      isCorrectInCorrectImageEnable = true;
      isEndMessageEnabled = true;
    } else {
      //問題数がある時
      Timer(Duration(seconds: 1), () => SetQuestion());
    }
    setState(() {});
  }

  void _playSound(bool isCorrect) async {
    if (isCorrect) {
      await _audioPlayer.setAsset("assets/sounds/sound_correct.mp3");
    } else {
      await _audioPlayer.setAsset("assets/sounds/sound_incorrect.mp3");
    }
    _audioPlayer.play();
  }

  //戻るボタン
  closeTestScreen() {
    Navigator.pop(context);
  }
}
