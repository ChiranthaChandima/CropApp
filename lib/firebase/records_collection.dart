import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/record_model.dart';


class RecordCollection{
  static Stream<List<RecordModel>> readAllUserRecords() {
    print("=======readAllUserRecords==========");
    final recordCollection = FirebaseFirestore.instance.collection("record");
    return recordCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => RecordModel.fromSnapshot(e)).toList());
  }

  static Stream<List<RecordModel>> readSelectedUserRecords(String id) {
    print("=======readselectedUserRecords==========");
    final recordCollection = FirebaseFirestore.instance.collection("record").where("userId", isEqualTo: id);
    return recordCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => RecordModel.fromSnapshot(e)).toList());
  }
}