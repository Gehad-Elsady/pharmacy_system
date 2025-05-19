class BatchModel {
  final String expiryDate;
  final int quantity;

  BatchModel({
    required this.expiryDate,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'expiryDate': expiryDate,
      'quantity': quantity,
    };
  }

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      expiryDate: json['expiryDate'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
