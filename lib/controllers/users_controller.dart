import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkie_tolkie_app/models/error_response.dart';
import 'package:walkie_tolkie_app/models/user_model.dart';

class UsersController {

  UsersController._privateConstructor();
  static final UsersController _instance = UsersController._privateConstructor();
  factory UsersController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final String usersCollection = "users";

  Future<dynamic> signInUserEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      if(credential.user != null){
        return credential.user;
      }else{
        return ErrorResponse.unknown;
      }
    } on FirebaseAuthException catch (e) {
      return ErrorResponse(
        statusCode: 400, 
        message: e.code
      );
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> recoverSession() async {
    try {
      final user = _auth.currentUser;
      if(user != null){
        return user;
      }else{
        return ErrorResponse.unknown;
      }
    } on FirebaseAuthException catch (e) {
      return ErrorResponse(
        statusCode: 400, 
        message: e.code
      );
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      return ErrorResponse(
        statusCode: 400, 
        message: e.code
      );
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }

  Future<dynamic> updateDocumentPhotos(String id, String photoUrlFrontal, String photoUrlRear) async {
    try{
      DocumentReference docsRef = _db.collection(usersCollection).doc(id);
      await docsRef.update({
        "doc_photo_url_frontal": photoUrlFrontal,
        "doc_photo_url_rear": photoUrlRear
      });
      return true;
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }

  Future<dynamic> fetchUserById(String id) async {
    try {
      DocumentSnapshot docsRef = await _db.collection(usersCollection).doc(id).get();
      final data = docsRef.data() as Map<String, dynamic>?;
      if (data != null) {
        return UserModel(
          id: id, 
          name: data["name"] ?? false,
        );
      }
      return ErrorResponse.notFound;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> fetchUsers(String id) async {
    try {
      QuerySnapshot docsRef = await _db.collection(usersCollection).get();
      if (docsRef.docs.isEmpty) {
        return List<UserModel>.empty();
      }
      return parseUsers(docsRef.docs);
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  List<UserModel> parseUsers(List<DocumentSnapshot<Object?>> docs){
    List<UserModel> users = [];
    for (DocumentSnapshot doc in docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        users.add(parseUser(data));
      }
    }
    return users;
  }
  UserModel parseUser(Map<String, dynamic> data){
    return UserModel(
      id: data["id"] ?? "", 
      name: data["name"] ?? false,
    );
  }
  Future<dynamic> createUser(UserModel user) async{
    try {
      final CollectionReference ref = _db.collection(usersCollection);
      final userRef = await ref.add({
        "id": user.id,
        "name": user.name, 
      });
      return userRef.id;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> sendVerificationCode(String countryCode, String phone) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}