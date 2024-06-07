import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel{
  final String? id;
  final String? instructorId;
  final String? review;
  final String? userId;
  final String? userName;


  ReviewModel({this.id, this.instructorId, this.review, this.userId, this.userName, });

  factory ReviewModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReviewModel(
      id: snap.reference.id,
      instructorId: snapshot['instructorId'],
      review: snapshot['review'],
      userId: snapshot['userId'],
      userName: snapshot['userName'],


    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "instructorId": instructorId,
    "review": review,
    "userId": userId,
    "userName": userName,
  };

  @override
  String toString() {
    return 'fullName: $userName';
  }


}