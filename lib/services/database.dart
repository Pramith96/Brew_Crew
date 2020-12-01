import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;

  DatabaseService({this.uid});

  // collection reference

  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserData (String sugar, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugar': sugar,
      'name': name,
      'strength': strength,
    });
  }

  //brews list from sbapshot

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
    return Brew(
      name: doc.data['name'] ?? '',
      sugars: doc.data['sugar'] ?? '0',
      strength: doc.data['strength'] ?? '',
    );

    }).toList();
  }

  // get brews streams

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

}