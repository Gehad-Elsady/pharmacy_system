import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/purchases/model/purchases_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/models/cart_item.dart';
import 'package:pharmacy_system/backend/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class MedicinSelles extends StatefulWidget {
  const MedicinSelles({super.key});

  @override
  State<MedicinSelles> createState() => _MedicinSellesState();
}

class _MedicinSellesState extends State<MedicinSelles> {
    final TextEditingController _searchController = TextEditingController();

    List<PurchasesModel> _filteredMedicines = [];

  void _filterMedicines(String query) {
    setState(() {
      _filteredMedicines = _filteredMedicines
          .where((medicine) =>
              medicine.medicineName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addToCart(PurchasesModel medicine) {
    final cart = Provider.of<SalesProvider>(context, listen: false);

    // Create a map of expiry dates to stock quantities
    Map<String, int> stockByExpiryDate = {};
    for (var batch in medicine.batches) {
      stockByExpiryDate[batch.expiryDate] = batch.quantity;
    }

    // Sort expiry dates and get the nearest one with available stock
    final sortedDates = stockByExpiryDate.entries
        .where((entry) => entry.value > 0)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (sortedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No stock available for this medicine'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nearestExpiryDate = sortedDates.first.key;

    final cartItem = CartItem(
      id: DateTime.now().toString(),
      medicineName: medicine.medicineName,
      price: double.parse(medicine.medicinePrice),
      quantity: 1,
      medicineId: medicine.medicineName,
      currentStock: medicine.medicineQuantity,
      reorderPoint: 2,
      expiryDate: nearestExpiryDate,
      smallUnitNumber: int.parse(medicine.medicineSmallUnitNumber),
      stockByExpiryDate: stockByExpiryDate,
    );
    cart.addItem(cartItem);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Medicines',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterMedicines,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<PurchasesModel>>(
                    stream: FirebaseFunctions.getInventoryData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No medicines available'));
                      }

                      if (_filteredMedicines.isEmpty) {
                        _filteredMedicines = snapshot.data!;
                      }

                      return ListView.builder(
                        itemCount: _filteredMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = _filteredMedicines[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(medicine.medicineName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price: \$${medicine.medicinePrice}'),
                                  Text('Stock: ${medicine.medicineQuantity}'),
                                  Text(
                                      'Expiry: ${medicine.medicineExpiryDate}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
                                onPressed: () => _addToCart(medicine),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
  }

    @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}