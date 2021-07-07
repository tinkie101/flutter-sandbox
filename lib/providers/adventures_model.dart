import 'package:flutter/foundation.dart';
import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/adventure/adventure_api.dart';

class AdventuresModel extends ChangeNotifier {
  List<Adventure> _adventures = List.empty();
  int? _selectedAdventureIndex;
  
  AdventuresModel() {
    fetchAllAdventures().then((adventures) => adventures != null? _adventures = adventures:_adventures);
  }

  List<Adventure> get adventures => _adventures.toList();

  Future fetchAllAdventures() async {
    _adventures = await AdventureApi.getAllAdventures();

    notifyListeners();
  }

  Future addAdventure(Adventure adventure) async {
    Adventure newAdventure = await AdventureApi.createAdventure(adventure);
    _adventures.add(newAdventure);

    notifyListeners();
  }

  Future updateAdventure(Adventure adventure) async {
    Adventure updatedAdventure = await AdventureApi.updateAdventure(adventure);

    var index = _adventures.indexWhere((element) => element.id == updatedAdventure.id);
    _adventures[index] = updatedAdventure;

    notifyListeners();
  }

  Future deleteAdventure(Adventure adventure) async {
    await AdventureApi.deleteAdventure(adventure);

    var index = _adventures.indexWhere((element) => element.id == adventure.id);
    _adventures.removeAt(index);

    if(index == index)
      _selectedAdventureIndex = null;

    notifyListeners();
  }

  Adventure? get selectedAdventure => _selectedAdventureIndex == null? null: _adventures[_selectedAdventureIndex!];

  set selectedAdventure(adventure){
    if(adventure == null)
      _selectedAdventureIndex = null;
    else
      _selectedAdventureIndex = _adventures.indexOf(adventure);

    notifyListeners();
  }
}