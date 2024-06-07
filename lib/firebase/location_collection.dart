import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/location_model.dart';

class LocationCollection{
  static Stream<List<LocationModel>> readAllLocations() {
    final locationCollection = FirebaseFirestore.instance.collection("location");
    return locationCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => LocationModel.fromSnapshot(e)).toList());
  }
}