import 'package:flutter/material.dart';
import 'package:instagram/model/user_model.dart';
import 'package:instagram/repositories/userRepository.dart';

class UserProvider with ChangeNotifier {
  UsersModel? user;
  final UserRepository _userRepository = UserRepository();
  bool isLoading = false;
  UsersModel get getUSer => user!;
  Future<void> refreshUser() async {
    try {

      UsersModel users = await _userRepository.getUsers();
      user = users;
      print(user);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
