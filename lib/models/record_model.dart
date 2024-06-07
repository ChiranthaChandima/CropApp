import 'package:cloud_firestore/cloud_firestore.dart';

class RecordModel{
  final String? id;
  final String? cause;
  final String? disease;
  final String? steps;
  final DateTime? timeStamp;
  final String? url;

  RecordModel({this.id, this.cause, this.disease, this.url, this.timeStamp, this.steps});

  factory RecordModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return RecordModel(
      id: snap.reference.id,
      cause: snapshot['cause'],
      disease: snapshot['disease'],
      steps: snapshot['steps'],
      timeStamp: snapshot['timeStamp'].toDate(),
      url: snapshot['url'],

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cause": cause,
    "disease": disease,
    "steps": steps,
    "timeStamp": timeStamp,
    "url": url,
  };

  @override
  String toString() {
    return 'cause: $cause, disease: $disease';
  }


}