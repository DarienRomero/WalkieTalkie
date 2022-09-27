import 'package:flutter/material.dart';
import 'package:walkie_tolkie_app/controllers/users_controller.dart';
import 'package:walkie_tolkie_app/models/error_response.dart';
import 'package:walkie_tolkie_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final usersController = UsersController();

  UserModel currentUser = UserModel.empty;
  bool currentUserLoading = false;
  bool currentUserError = false;
  
  Future<void> getCurrentUser(String id) async {
    // if(currentUser.id != "-1") return;
    currentUserLoading = true;
    currentUserError = false;
    notifyListeners();
    final data = await usersController.fetchUserById(id);
    if(data is ErrorResponse){
      currentUserLoading = false;
      currentUserError = true;
      notifyListeners();
      return;
    }
    currentUser = data as UserModel;
    currentUserLoading = false;
    currentUserError = false;
    notifyListeners();
  }
  void setNewUser(UserModel newUser){
    currentUser = newUser;
    notifyListeners();
  }
}