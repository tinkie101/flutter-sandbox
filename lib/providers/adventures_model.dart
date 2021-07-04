import 'package:flutter/foundation.dart';
import 'package:flutter_sandbox/api/adventure/adventure.dart';
import 'package:flutter_sandbox/api/adventure/adventure_api.dart';

class AdventuresModel extends ChangeNotifier {
  List<Adventure> _adventures = List.empty();
  Adventure? _selectedAdventure;
  
  AdventuresModel() {
    fetchAllAdventures().then((adventures) => adventures != null? _adventures = adventures:_adventures);
  }

  List<Adventure> get adventures => _adventures.toList();

  Future fetchAllAdventures() async {
    _adventures = await AdventureApi().getAllAdventures();

    notifyListeners();
  }

  Adventure? get selectedAdventure => _selectedAdventure;

  set selectedAdventure(adventure){
    _selectedAdventure = adventure;
    notifyListeners();
  }
}