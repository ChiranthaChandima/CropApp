import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel{
  final String? id;
  final String? district;
  final String? division;

  LocationModel({this.id, this.district, this.division});

  factory LocationModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LocationModel(
        id: snap.reference.id,
      district: snapshot['district'],
      division: snapshot['division'],

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "district": district,
    "division": division,
  };

  @override
  String toString() {
    return 'Location: $district, Division: $division';
  }


}