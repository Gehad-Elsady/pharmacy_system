import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class InventoryScreen extends StatelessWidget {
  static const String routeName = "inventory";
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Inventory",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFunctions.getInventoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Enable vertical scrolling
                child: DataTable(
                  columnSpacing: 70,
                  dividerThickness: 2,
                  headingRowHeight: 50,
                  headingTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!),
                  border: TableBorder.all(color: Colors.black),
                  columns: const [
                    DataColumn(label: Text('Medicine Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Expiry Date')),
                    DataColumn(label: Text('Number of Small Units')),
                    DataColumn(label: Text('Small Units')),
                    DataColumn(label: Text('Creation Date')),
                    DataColumn(label: Text('Supplier ID')),
                    DataColumn(label: Text('Invoice Number')),
                  ],
                  rows: snapshot.data!.map<DataRow>((medicine) {
                    return DataRow(cells: [
                      DataCell(
                        Text(medicine.medicineName ?? 'N/A'),
                        showEditIcon: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Edit Medicine'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicineName,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Medicine Name',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicineQuantity
                                            .toString(),
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicinePrice.toString(),
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Price',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicineExpiryDate,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Expiry Date',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicineSmallUnitNumber
                                            .toString(),
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Number of Small Units',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.medicineSmallUnit,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Small Units',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.supplierId,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Supplier ID',
                                      ),
                                    ),
                                    TextField(
                                      controller: TextEditingController(
                                        text: medicine.invoiceId,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Invoice ID',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      DataCell(Center(
                          child: Text(
                              medicine.medicineQuantity?.toString() ?? 'N/A'))),
                      DataCell(Center(
                          child: Text(
                              medicine.medicinePrice?.toString() ?? 'N/A'))),
                      DataCell(Center(
                          child: Text(medicine.medicineExpiryDate ?? 'N/A'))),
                      DataCell(Center(
                          child: Text(
                              medicine.medicineSmallUnitNumber?.toString() ??
                                  'N/A'))),
                      DataCell(Center(
                          child: Text(medicine.medicineSmallUnit ?? 'N/A'))),
                      DataCell(Center(
                          child: Text(
                              "${medicine.dateOfDay ?? 'N/A'} | ${medicine.timeOfDay ?? 'N/A'}"))),
                      DataCell(
                          Center(child: Text(medicine.supplierId ?? 'N/A'))),
                      DataCell(
                          Center(child: Text(medicine.invoiceId ?? 'N/A'))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
