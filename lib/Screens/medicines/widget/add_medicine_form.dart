import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class AddMedicineForm extends StatelessWidget {
  AddMedicineForm({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // name and phone
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color when focused
                        width: 2.0, // Border width
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.medication,
                      color: Colors.white,
                    ),
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    // Define the border
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
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
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                  controller: priceController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color when focused
                        width: 2.0, // Border width
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.attach_money_outlined,
                      color: Colors.white,
                    ),
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    // Define the border
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
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
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              fixedSize: Size(200, 50),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (nameController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Please fill in all required fields.")),
                );
                return;
              }

              // Create employee model
              MedicineModel medicine = MedicineModel(
                name: nameController.text,
                price: priceController.text,
              );

              try {
                await FirebaseFunctions.addMedicine(
                  medicine,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    ));
  }
}
