import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';

class SharedPrefScreen extends StatelessWidget {
  const SharedPrefScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared preferences demo',
      home: MyHomePage(storage: CounterStorage()),
    );
  }
}

class CounterStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    }
    catch (e) {
      return 0;
    }
  }


  Future<File> writeCounter(int counterf) async {
    final file = await _localFile;
    return file.writeAsString('$counterf');
  }

}


class MyHomePage extends StatefulWidget {
 // const MyHomePage({Key? key, required this.title}) : super(key: key);
  const MyHomePage({Key? key, required this.storage}) : super(key: key);
 // final String title;

  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 40),
    primary: Colors.purple,);



  int _counterf = 0;
  int _counter = 0;
  int _counterMinus = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    widget.storage.readCounter().then((int value) {
    setState(() {
      _counterf = value;
    });
    });
  }


  Future<File> _incrementCounterf(){
    setState(() {
      _counterf++;
    });
    return widget.storage.writeCounter(_counterf);
  }






  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0 );
      _counterMinus = (prefs.getInt('counterMinus') ?? 0 );
    });
  }

void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter=(prefs.getInt('counter') ?? 0 )+1;
      prefs.setInt('counter', _counter);
    });
}

  void _incrementCounterMinus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counterMinus = (prefs.getInt('counterMinus') ?? 0) - 1;
      prefs.setInt('counterMinus', _counterMinus);
    });
  }

  void _decrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter=(prefs.getInt('counter') ?? 0 )-1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case 3.1 Storage"),//widget.title
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton.icon(
              onPressed: () {
                _incrementCounter();
              },
              label: const Text('plus'),
              style: style,
              icon: const Icon(Icons.arrow_circle_up_rounded),
            ),

            ElevatedButton.icon(
              onPressed: () {
                _decrementCounter();
                _incrementCounterMinus();
              },
              label: const Text('minus'),
              style: style,
              icon: const Icon(Icons.arrow_circle_down_rounded),
            ),



            const Text("Total Count is:"
      ),
        Text(
          '$_counter', style: Theme.of(context).textTheme.headline6,
        ),

            const Text("You've minused:"
            ),
            Text(
              '$_counterMinus', style: Theme.of(context).textTheme.headline6,
            ),

            const Text("Total Count is (storage in file):"
            ),
            Text(
              '$_counterf', style: Theme.of(context).textTheme.headline6,
            ),


            SizedBox(height:40),
            Text("Приложение для работы со счетчиком"),
            SizedBox(height:10),
            Text("Gorlanov AA Homework case 3.1"),
          ],
        ),
      ),



      floatingActionButton: FloatingActionButton.extended(
        label: Text('Storage +1'),
        backgroundColor: Colors.red,
        onPressed: _incrementCounterf,
        tooltip: "Add +1",
        foregroundColor: Colors.black,
        icon: Icon(Icons.add),
        //child: const Icon(Icons.add),
      ),
    );
  }


}


