class PurchasesModel {
  String supplierId; //
  String invoiceId; //
  String dateOfDay; //
  String timeOfDay; //
  String medicineName; //
  String medicinePrice; //
  int medicineQuantity; //
  String medicineExpiryDate; //
  String medicineSmallUnit; //
  String medicineSmallUnitNumber; //
  String totalPrice;
  String userId;
  PurchasesModel({
    required this.supplierId,
    required this.invoiceId,
    required this.dateOfDay,
    required this.timeOfDay,
    required this.medicineName,
    required this.medicinePrice,
    required this.medicineQuantity,
    required this.medicineExpiryDate,
    required this.medicineSmallUnit,
    required this.medicineSmallUnitNumber,
    required this.totalPrice,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'invoiceId': invoiceId,
      'dateOfDay': dateOfDay,
      'timeOfDay': timeOfDay,
      'medicineName': medicineName,
      'medicinePrice': medicinePrice,
      'medicineQuantity': medicineQuantity,
      'medicineExpiryDate': medicineExpiryDate,
      'medicineSmallUnit': medicineSmallUnit,
      'medicineSmallUnitNumber': medicineSmallUnitNumber,
      'totalPrice': totalPrice,
      'userId': userId,
    };
  }

  static PurchasesModel fromJson(Map<String, dynamic> json) {
    return PurchasesModel(
      supplierId: json['supplierId'],
      invoiceId: json['invoiceId'],
      dateOfDay: json['dateOfDay'],
      timeOfDay: json['timeOfDay'],
      medicineName: json['medicineName'],
      medicinePrice: json['medicinePrice'],
      medicineQuantity: json['medicineQuantity'],
      medicineExpiryDate: json['medicineExpiryDate'],
      medicineSmallUnit: json['medicineSmallUnit'],
      medicineSmallUnitNumber: json['medicineSmallUnitNumber'],
      totalPrice: json['totalPrice'],
      userId: json['userId'],
    );
  }
}
