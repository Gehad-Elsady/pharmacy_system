class MedicineModel {
  String name;
  String price;
  String? expiryDate;
  String? quantity;
  MedicineModel(
      {required this.name,
      required this.price,
      this.expiryDate,
      this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'expiryDate': expiryDate,
      'quantity': quantity
    };
  }

  static MedicineModel fromJson(
    Map<String, dynamic> jason,
  ) {
    return MedicineModel(
      name: jason['name'],
      price: jason['price'],
      expiryDate: jason['expiryDate'],
      quantity: jason['quantity'],
    );
  }
}
