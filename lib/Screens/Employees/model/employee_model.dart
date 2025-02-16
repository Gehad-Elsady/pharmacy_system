import 'dart:convert';

class EmployeeModel {
  String? id; // Firestore document ID (optional)
  String name;
  String email;
  String phoneNumber;
  String address;
  String specialization;
  String experience;
  String qualifications;
  String salary;
  String password;
  String role;

  EmployeeModel({
    this.id, // Optional Firestore document ID
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.role,
    required this.salary,
    required this.password,
    required this.specialization,
    required this.experience,
    required this.qualifications,
  });

  /// Convert model to JSON (Firestore-compatible)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'specialization': specialization,
      'experience': experience,
      'qualifications': qualifications,
      'password': password,
      'salary': salary,
      'role': role,
      'userId': id,
    };
  }

  /// Convert JSON (Firestore document) to EmployeeModel
  factory EmployeeModel.fromJson(
    Map<String, dynamic> jason,
  ) {
    return EmployeeModel(
      id: jason['id'], // Assign Firestore document ID separately
      name: jason['name'] as String,
      email: jason['email'] as String,
      phoneNumber: jason['phoneNumber'] as String,
      address: jason['address'] as String,
      specialization: jason['specialization'] as String,
      experience: jason['experience'] as String,
      qualifications: jason['qualifications'] as String,
      password: jason['password'] as String,
      salary: jason['salary'] as String,
      role: jason['role'] as String,
    );
  }
}
