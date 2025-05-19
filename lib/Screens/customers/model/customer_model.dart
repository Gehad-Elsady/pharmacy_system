import 'package:pharmacy_system/backend/models/cart_model.dart';

class CustomerModel {
  String name;
  String phoneNumber;
  String address;
  String email;
  String age;

  CustomerModel({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'age': age,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? '',
    );
  }
}
