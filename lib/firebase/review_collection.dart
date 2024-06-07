import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:crop_doc/models/review_modal.dart';


class ReviewCollection{
  static Stream<List<ReviewModel>> readAllReviews() {
    final instructorCollection = FirebaseFirestore.instance.collection("review");
    return instructorCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReviewModel.fromSnapshot(e)).toList());
  }

  static Stream<List<ReviewModel>> readSelectedInstReviews(String instructorId) {
    final instructorCollection = FirebaseFirestore.instance.collection("review").where("instructorId", isEqualTo: instructorId);
    return instructorCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReviewModel.fromSnapshot(e)).toList());
  }
}