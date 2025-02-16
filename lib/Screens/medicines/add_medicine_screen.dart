import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/Screens/medicines/widget/add_medicine_form.dart';
import 'package:pharmacy_system/Screens/medicines/widget/medicine_list.dart';

class AddMedicineScreen extends StatelessWidget {
  static const String routeName = 'add_medicine';
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Add Medicine',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=1779&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          kIsWeb
              ? Row(
                  children: [
                    Expanded(flex: 1, child: AddMedicineForm()),
                    Expanded(flex: 1, child: MedicineList()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 1, child: AddMedicineForm()),
                    Expanded(flex: 1, child: MedicineList()),
                  ],
                ),
        ],
      ),
    );
  }
}
