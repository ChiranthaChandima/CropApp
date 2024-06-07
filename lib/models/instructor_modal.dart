import 'package:cloud_firestore/cloud_firestore.dart';

class InstructorModel{
  final String? id;
  final bool? adminApproval;
  final String? district;
  final String? division;
  final String? email;
  final String? fullName;
  final String? mobileNo;
  final String? nic;
  final String? workingId;

  InstructorModel({this.id, this.adminApproval, this.district, this.division, this.email, this.fullName, this.mobileNo, this.nic, this.workingId});

  factory InstructorModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return InstructorModel(
      id: snap.reference.id,
      adminApproval: snapshot['adminApproval'],
      district: snapshot['district'],
      division: snapshot['division'],
      email: snapshot['email'],
      fullName: snapshot['fullName'],
      mobileNo: snapshot['mobileNo'],
      nic: snapshot['nic'],
      workingId: snapshot['workingId'],

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "adminApproval": adminApproval,
    "district": district,
    "division": division,
    "email": email,
    "fullName": fullName,
    "mobileNo": mobileNo,
    "nic": division,
    "workingId": workingId,
  };

  @override
  String toString() {
    return 'fullName: $fullName, adminApproval: $adminApproval';
  }


}