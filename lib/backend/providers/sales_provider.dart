import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class SalesProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  int get itemCount => _items.length;

  void addItem(CartItem item) {
    final existingIndex =
        _items.indexWhere((i) => i.medicineId == item.medicineId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String medicineId) {
    _items.removeWhere((item) => item.medicineId == medicineId);
    notifyListeners();
  }

  void updateQuantity(String medicineId, int quantity) {
    final index = _items.indexWhere((item) => item.medicineId == medicineId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void updateItem(CartItem updatedItem) {
    final index =
        _items.indexWhere((item) => item.medicineId == updatedItem.medicineId);
    if (index >= 0) {
      if (updatedItem.quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = updatedItem;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
