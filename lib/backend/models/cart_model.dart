import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_system/backend/models/cart_item.dart';

class CartModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  String customerPhoneNumber;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.customerPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'customerPhoneNumber': customerPhoneNumber,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Handle both int and double for total field
    final total = json['total'] is int 
        ? (json['total'] as int).toDouble()
        : json['total'] as double;
        
    return CartModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: total,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      customerPhoneNumber: json['customerPhoneNumber'] as String,
    );
  }
}
