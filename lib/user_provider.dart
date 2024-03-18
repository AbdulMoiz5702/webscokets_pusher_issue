import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_controller.dart';

// user_model.dart
class UserModel {
  final int id;
  final int userId;
  final String gender;
  final double height;
  final double weight;
  final int age;
  final List<String> goal;
  final List<String> focus;
  final String experience;
  final String equipment;
  final List<String> interest;
  final String name;

  UserModel({
    required this.id,
    required this.userId,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.focus,
    required this.experience,
    required this.equipment,
    required this.interest,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['user_id'],
      gender: json['gender'],
      height: double.parse(json['height']),
      weight: double.parse(json['weight']),
      age: json['age'],
      goal: _parseList(json['goal']),
      focus: _parseList(json['focus']),
      experience: json['experience'],
      equipment: json['equipment'],
      interest: _parseList(json['interest']),
      name: json['name'],
    );
  }



  static List<String> _parseList(dynamic data) {
    if (data is List) {
      return List<String>.from(data);
    } else if (data is String) {
      return [data];
    } else {
      return [];
    }
  }

  static List<List<String>> _parseNestedList(dynamic data) {
    if (data is List) {
      return List<List<String>>.from(data.map((nestedList) => _parseList(nestedList)));
    } else {
      return [];
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String isAssigned;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAssigned,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isAssigned: json['is_assigned'],
    );
  }
}



class UserInformationProvider extends ChangeNotifier {
  List<UserModel> usersInformation = [];
  Future<void> getUsersInformation() async {
    final url = Uri.parse(ApiServices.getAllUsersInfo);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Assuming the list of users is under the 'data' key
        final List<dynamic> userData = responseData['data'];
        usersInformation = userData.map((json) => UserModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        // Handle error cases
        print('Failed to load users information');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
    }
  }

  List<User> _users = [];
  List<User> get users => _users;
  void fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(ApiServices.getAllProgramAssignedUser));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        _users = data.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }


  List<User> _unassignedUsers = [];
  List<User> get unassignedUsers => _unassignedUsers;

  void fetchUnassignedUsers() async {
    try {
      final response = await http.get(Uri.parse(ApiServices.getAllUnAssignedUser));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        _unassignedUsers = data.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load unassigned users');
      }
    } catch (e) {
      print('Error fetching unassigned users: $e');
    }
  }
}

