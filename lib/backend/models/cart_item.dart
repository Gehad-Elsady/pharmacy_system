class CartItem {
  final String id;
  final String medicineName;
  final double price;
  int quantity;
  final String medicineId;
  final int currentStock;
  final int reorderPoint;
  double discountPercentage;
  String expiryDate; // Changed to non-final to allow selection
  final int smallUnitNumber; // Number of units in one strip
  String selectedUnit; // 'strip' or 'unit'
  final Map<String, int>
      stockByExpiryDate; // Map of expiry date to available stock

  CartItem({
    required this.id,
    required this.medicineName,
    required this.price,
    required this.quantity,
    required this.medicineId,
    required this.currentStock,
    required this.reorderPoint,
    required this.expiryDate,
    required this.smallUnitNumber,
    required this.stockByExpiryDate,
    this.selectedUnit = 'strip',
    this.discountPercentage = 0.0,
  });

  // Get available stock for current expiry date
  int get availableStock {
    return stockByExpiryDate[expiryDate] ?? 0;
  }

  // Get total available stock across all expiry dates
  int get totalAvailableStock {
    return stockByExpiryDate.values.fold(0, (sum, stock) => sum + stock);
  }

  // Get list of expiry dates sorted by nearest first
  List<String> get sortedExpiryDates {
    final dates = stockByExpiryDate.keys.toList();
    dates.sort(); // Sort dates in ascending order
    return dates;
  }

  // Check if current quantity exceeds available stock
  bool get isQuantityValid {
    if (selectedUnit == 'strip') {
      return quantity <= (availableStock / smallUnitNumber).floor();
    } else {
      return quantity <= availableStock;
    }
  }

  // Get maximum allowed quantity based on current unit
  int get maxAllowedQuantity {
    if (selectedUnit == 'strip') {
      return (availableStock / smallUnitNumber).floor();
    } else {
      return availableStock;
    }
  }

  double get total {
    if (selectedUnit == 'strip') {
      return price * quantity;
    } else {
      // If units are selected, calculate price per unit
      return (price / smallUnitNumber) * quantity;
    }
  }

  double get totalBeforeDiscount => total;
  double get discountAmount => totalBeforeDiscount * (discountPercentage / 100);
  double get finalPrice => totalBeforeDiscount - discountAmount;

  // Convert units to strips
  int get totalUnits {
    if (selectedUnit == 'strip') {
      return quantity * smallUnitNumber;
    }
    return quantity;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'price': price,
      'quantity': quantity,
      'medicineId': medicineId,
      'currentStock': currentStock,
      'reorderPoint': reorderPoint,
      'discountPercentage': discountPercentage,
      'expiryDate': expiryDate,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'price': price,
      'quantity': quantity,
      'medicineId': medicineId,
      'currentStock': currentStock,
      'reorderPoint': reorderPoint,
      'expiryDate': expiryDate,
      'smallUnitNumber': smallUnitNumber,
      'selectedUnit': selectedUnit,
      'discountPercentage': discountPercentage,
      'stockByExpiryDate': stockByExpiryDate,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Handle both int and double for price field
    final price = json['price'] is int 
        ? (json['price'] as int).toDouble()
        : json['price'] as double;
        
    // Handle both int and double for discountPercentage
    final discountPercentage = json['discountPercentage'] is int
        ? (json['discountPercentage'] as int).toDouble()
        : (json['discountPercentage'] as double?) ?? 0.0;
        
    return CartItem(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      price: price,
      quantity: json['quantity'] as int,
      medicineId: json['medicineId'] as String,
      currentStock: json['currentStock'] as int,
      reorderPoint: json['reorderPoint'] as int,
      expiryDate: json['expiryDate'] as String,
      smallUnitNumber: json['smallUnitNumber'] as int,
      selectedUnit: json['selectedUnit'] as String? ?? 'strip',
      discountPercentage: discountPercentage,
      stockByExpiryDate: Map<String, int>.from(json['stockByExpiryDate'] as Map),
    );
  }
}
