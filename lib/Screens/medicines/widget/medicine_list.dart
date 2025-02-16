import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';

class MedicineList extends StatefulWidget {
  const MedicineList({super.key});

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  String query = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              query = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search for Medicines...",
            hintStyle: const TextStyle(color: Colors.white),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            // Define the border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              borderSide: const BorderSide(
                color: Colors.white, // Border color
                width: 2.0, // Border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.white, // Border color when enabled
                width: 2.0, // Border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.blue, // Border color when focused
                width: 2.0, // Border width
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Medicines').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Medicines found."));
                  }

                  final results = snapshot.data!.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final price = doc['price'].toString().toLowerCase();
                    return name.contains(query) ||
                        price == query; // Exact match for price
                  }).toList();

                  if (results.isEmpty) {
                    return const Center(
                        child: Text("No matching Medicines found."));
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final model = results[index];
                      final medicien = MedicineModel.fromJson(
                          model.data() as Map<String, dynamic>);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Medicine Information",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Medicine Name : ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: medicien.name,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Medicine Price : ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: medicien.price,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  );
                }))
      ],
    );
  }
}
