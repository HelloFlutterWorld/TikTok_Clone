import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  // create profile
  Future<void> createProfile() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
  }

  // get profile
  // update profile
}

final userRepo = Provider((ref) => UserRepository());
