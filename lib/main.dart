import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/adventure.dart';
import 'package:flutter_sandbox/api/adventure_api.dart';
import 'package:flutter_sandbox/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(kApi);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<List<Adventure>>? adventuresFuture;

  @override
  void initState() {
    super.initState();

    adventuresFuture = AdventureApi.getAllAdventures();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: adventuresFuture,
      builder: (context, snapshot) {
        print(snapshot);
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if(snapshot.hasData) {
          var adventures = snapshot.data as List<Adventure>;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        ...List.generate(adventures.length, (index) => Text(adventures.elementAt(index).description))
                      ],
                    ),
                  ),
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        } else
          return Center(child: Text("Something went wrong"));
      }
    );
  }
}
