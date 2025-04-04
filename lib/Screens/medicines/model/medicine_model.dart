class MedicineModel {
  String? id;
  String name;
  String price;
  String? userId;

  MedicineModel({
    required this.name,
    required this.price,
    this.id,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'id': id,
      'userId': userId,
    };
  }

  static MedicineModel fromJson(
    Map<String, dynamic> jason,
  ) {
    return MedicineModel(
      name: jason['name'],
      price: jason['price'],
      id: jason['id'],
      userId: jason['userId'],
    );
  }
}
