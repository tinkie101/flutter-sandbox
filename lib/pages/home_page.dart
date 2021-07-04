import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/adventure/adventure_api.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Adventure>>? adventuresFuture;

  @override
  void initState() {
    super.initState();

    adventuresFuture = AdventureApi().getAllAdventures();
  }

  void _addAdventure() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: adventuresFuture,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            var adventures = snapshot.data as List<Adventure>;
            return Scaffold(
              appBar: AppBar(
                title: Text("Home page"),
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("List of adventures:", style: TextStyle(fontSize: 24),),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.80,
                      child: ListView.builder(
                        itemCount: adventures.length,
                        itemBuilder: (context, index) => InkWell(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(adventures.elementAt(index).description),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ]),
              floatingActionButton: FloatingActionButton(
                onPressed: _addAdventure,
                tooltip: 'New Adventure',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: Text("Something went wrong"));
          }
        });
  }
}
