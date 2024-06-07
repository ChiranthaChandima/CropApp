import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  DocumentSnapshot<Object?>? _currentUser;

  DocumentSnapshot<Object?>? get currentUser => _currentUser;

  set currentUser(DocumentSnapshot<Object?>? userData) {
    _currentUser = userData;
    notifyListeners();
  }

}