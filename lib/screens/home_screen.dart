import 'package:calc_app/screens/test_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _menuItems = [];
  int _numberOfQuestions = 0; //初期値0
  @override
  void initState() {
    super.initState();
    setMenuItems();

    _numberOfQuestions = _menuItems[0].value!;
  }

  void setMenuItems() {
    // _menuItems.add(DropdownMenuItem(
    //   value: 10,
    //   child: Text(10.toString()),
    // ));
    // _menuItems.add(DropdownMenuItem(
    //   value: 20,
    //   child: Text(20.toString()),
    // ));
    // _menuItems.add(DropdownMenuItem(
    //   value: 30,
    //   child: Text(30.toString()),
    // ));

    // cascade notation
    _menuItems
      ..add(DropdownMenuItem(
        value: 10,
        child: Text(10.toString()),
      ))
      ..add(DropdownMenuItem(
        value: 20,
        child: Text(20.toString()),
      ))
      ..add(DropdownMenuItem(
        value: 30,
        child: Text(30.toString()),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/image_title.png"),
              const SizedBox(height: 50.0), //constでパフォーマンス向上
              const Text(
                "問題を選択して「スタート」ボタンを押してださい",
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 100.0),
              DropdownButton(
                  items: _menuItems,
                  value: _numberOfQuestions,
                  onChanged: (int? selectedValue) {
                    setState(() {
                      _numberOfQuestions = selectedValue!;
                    });
                  }),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.skip_next), //アイコン付きのボタン
                        onPressed: () => startTestScreen(context),
                        label: Text("スタート"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      )))
            ],
          ),
        ),
      )),
    );
  }

  startTestScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreen(
                  numberOfQuestions: _numberOfQuestions,
                )));
  }
}
