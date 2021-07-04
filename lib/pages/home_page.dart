import 'package:flutter/material.dart';
import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/adventure/adventure_api.dart';
import 'package:flutter_sandbox/providers/adventures_model.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  void _addAdventure() {}

  @override
  Widget build(BuildContext context) {
    print("build");

    return Consumer<AdventuresModel>(
      builder: (context, adventuresModel, child) => Navigator(
          pages: [
            MaterialPage(
              key: ValueKey("AdventureList"),
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Home page"),
                ),
                body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "List of adventures:",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.80,
                    child: ListView.builder(
                      itemCount: adventuresModel.adventures.length,
                      itemBuilder: (context, index) => InkWell(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(adventuresModel.adventures.elementAt(index).description),
                            ),
                          ],
                        ),
                        onTap: () {
                          adventuresModel.selectedAdventure = adventuresModel.adventures.elementAt(index);
                        },
                      ),
                    ),
                  ),
                ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: _addAdventure,
                  tooltip: 'New Adventure',
                  child: Icon(Icons.add),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              ),
            ),
            if (adventuresModel.selectedAdventure != null)
              MaterialPage(
                  key: ValueKey("AdventureDetail"),
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("Adventure details"),
                    ),
                    body: Center(child: Text(adventuresModel.selectedAdventure!.description)),
                  )),
          ],
          onPopPage: (route, result) {
            return route.didPop(result);
          }),
    );
  }
}
