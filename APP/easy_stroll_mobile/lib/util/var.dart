import 'db.dart';
import 'api_key.dart';  // Create a dart file 'api_key.dart' in this folder
                        // Then write String GMAP_API_KEY = 'XX';
import 'package:google_maps_webservice/geocoding.dart';
// User auth stuff
String _userId;

bool userLoggedIn() => _userId != null;

void setUserId(String uid) => _userId = uid;

String getUserId() => _userId;


// DB stuff
DB _db;

DB getDB() {
  if(_db != null)
    return _db;
  assert(userLoggedIn(), "User not logged in");
  if(!userLoggedIn())
    return null;
  _db = EasyStrollDB(_userId);
  return _db;
}

// Walker stuff
String _currentWalkerIndex;
List<Map> _allWaker = [];

// Gmap services stuff
GoogleMapsGeocoding getGeoCoding() => new GoogleMapsGeocoding(apiKey: GMAP_API_KEY);