
import 'package:cloud_firestore/cloud_firestore.dart';

class TerritorySetupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //initializes fireBase and the territories
  Future<void> initializeTerritories() async {
    final territories = [
      {
        'id': 'auckland_domain_track',
        'territoryName': 'Auckland Domain Track',
        'imageUrl': 'assets/auckland_domain_track.png',
        'fastestTimeSeconds': 0,
        'currentOwner': ' ',
        'runId': '',
      },
      {
        'id': 'cornwall_park_one_tree_hill_track',
        'territoryName': 'Cornwall Park Track',
        'imageUrl': 'assets/cornwall_park_track.png',
        'fastestTimeSeconds': 0,
        'currentOwner': ' ',
        'runId': '',
      },
      {
        'id': 'shakespear_regional_park_track',
        'territoryName': 'Shakespear Regional Track',
        'imageUrl': 'assets/shakespear_regional_park_track.png',
        'fastestTimeSeconds': 0,
        'currentOwner': ' ',
        'runId': '',
      },
      {
        'id': 'waitakere_ranges_track',
        'territoryName': 'Waitakere Ranges Track',
        'imageUrl': 'assets/waitakere_ranges_track.png',
        'fastestTimeSeconds': 0,
        'currentOwner': ' ',
        'runId': '',
      },
    ];

    for (final territory in territories) {
      final id = territory['id'] as String;
      final docRef = _db.collection('territories').doc(id);
      final doc = await docRef.get();

      //only creates if doesn't exist yt
      if (!doc.exists) {
        await docRef.set(territory);
      }
    }
  }
}