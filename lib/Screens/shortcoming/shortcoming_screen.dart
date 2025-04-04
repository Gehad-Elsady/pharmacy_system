import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class ShortcomingScreen extends StatelessWidget {
  static const String routeName = 'shortcoming';
  const ShortcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime oneMonthFromNow = now.add(Duration(days: 30));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Shortcoming",
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
        stream: FirebaseFunctions.getShortcomingsData(),
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
                  columnSpacing: 125,
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
                    DataColumn(
                      label: Text('Price'),
                    ),
                    DataColumn(label: Text('Expiry Date')),
                    DataColumn(
                        label: Text(
                      'Number of Small Units',
                    )),
                    DataColumn(label: Text('Small Units')),
                    DataColumn(label: Text('Creation Date')),
                  ],
                  rows: snapshot.data!.map<DataRow>((medicine) {
                    return DataRow(cells: [
                      DataCell(
                        Text(medicine.medicineName ?? 'N/A'),
                      ),
                      DataCell(Center(
                        child: Text(
                          medicine.medicineQuantity?.toString() ?? 'N/A',
                          style: medicine.medicineQuantity < 6
                              ? TextStyle(color: Colors.red, fontSize: 18)
                              : TextStyle(color: Colors.black),
                        ),
                      )),
                      DataCell(Center(
                          child: Text(
                              medicine.medicinePrice?.toString() ?? 'N/A'))),
                      DataCell(Center(
                        child: Text(
                          medicine.medicineExpiryDate ?? 'N/A',
                          style: (DateTime.tryParse(
                                          medicine.medicineExpiryDate ?? '') ??
                                      DateTime(2100))
                                  .isBefore(oneMonthFromNow)
                              ? const TextStyle(color: Colors.red)
                              : const TextStyle(color: Colors.black),
                        ),
                      )),
                      DataCell(Center(
                          child: Text(
                              medicine.medicineSmallUnitNumber?.toString() ??
                                  'N/A'))),
                      DataCell(Center(
                          child: Text(medicine.medicineSmallUnit ?? 'N/A'))),
                      DataCell(Center(
                        child: Text(
                          "${medicine.dateOfDay ?? 'N/A'} | ${medicine.timeOfDay ?? 'N/A'}",
                        ),
                      )),
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
