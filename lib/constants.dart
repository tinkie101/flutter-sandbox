import 'package:flutter/foundation.dart' show kIsWeb;

final kApiSecure = false;
final kApi = kIsWeb? "localhost:9090" : "10.0.2.2:9000";