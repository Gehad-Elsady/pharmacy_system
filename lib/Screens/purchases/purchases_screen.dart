import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/Screens/medicines/widget/medicine_list.dart';
import 'package:pharmacy_system/Screens/purchases/widget/medicine_purchases_list.dart';
import 'package:pharmacy_system/Screens/purchases/widget/purchase_part.dart';

class PurchasesScreen extends StatelessWidget {
  static const String routeName = "purchases";
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.blueGrey,
                      title: Text(
                        "Add medicine purchase",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height:
                            600, // Set a fixed height to avoid unbounded error
                        width: 600, // Set a fixed width
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 600, // Ensure bounded height
                            child: MedicinePurchasesList(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              elevation: 15,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              icon: Icon(Icons.add, color: Colors.white), // Add icon
              label: Text(
                "Add Medicine",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Add Purchase',
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
              "https://www.appier.com/hubfs/Imported_Blog_Media/7-Powerful-Strategies-to-Increase-Repeat-Purchase-3.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          kIsWeb
              ? Row(
                  children: [
                    Expanded(flex: 3, child: PurchasePart()),
                    Expanded(flex: 1, child: MedicinePurchasesList()),
                  ],
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 3,
                      child: PurchasePart()))
        ],
      ),
    );
  }
}
