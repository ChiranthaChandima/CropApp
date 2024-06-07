import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/instructor_modal.dart';


class InstructorCollection{
  static Stream<List<InstructorModel>> readAllUserRecords() {
    final instructorCollection = FirebaseFirestore.instance.collection("instructor");
    return instructorCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => InstructorModel.fromSnapshot(e)).toList());
  }

  static Stream<List<InstructorModel>> readApprovedInstructors(String district) {
    final instructorCollection = FirebaseFirestore.instance.collection("instructor").where("adminApproval", isEqualTo: true).where("district", isEqualTo: district);
    
    return instructorCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => InstructorModel.fromSnapshot(e)).toList());
  }


}