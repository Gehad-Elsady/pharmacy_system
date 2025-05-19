import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/Screens/Employees/employees_screen.dart';
import 'package:pharmacy_system/Screens/analysis/analysis_screen.dart';
import 'package:pharmacy_system/Screens/customers/customer_screen.dart';
import 'package:pharmacy_system/Screens/inventory/inventory_screen.dart';
import 'package:pharmacy_system/Screens/medicines/add_medicine_screen.dart';
import 'package:pharmacy_system/Screens/purchases/purchases_screen.dart';
import 'package:pharmacy_system/Screens/selles/selles_screen.dart';
import 'package:pharmacy_system/Screens/shortcoming/shortcoming_screen.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Home Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              FirebaseFunctions.signOut();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://plus.unsplash.com/premium_photo-1661766456250-bbde7dd079de?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.blue.withOpacity(0.3),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kIsWeb ? 3 : 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio:
                          kIsWeb ? 3 : 1, // 3 for web, 1 for mobile
                    ),
                    children: [
                      _buildGridItem("Inventory", Icons.inventory_2_outlined,
                          () {
                        Navigator.pushNamed(context, InventoryScreen.routeName);
                      }),
                      _buildGridItem("Sells", Icons.shopping_cart_outlined, () {
                        Navigator.pushNamed(context, SellsScreen.routeName);
                      }),
                      _buildGridItem("Medicine", Icons.medication_rounded, () {
                        Navigator.pushNamed(
                            context, AddMedicineScreen.routeName);
                      }),
                      _buildGridItem("Employees", Icons.people_outline, () {
                        Navigator.pushNamed(context, EmployeesScreen.routeName);
                      }),
                      _buildGridItem(
                          "Shortcoming", Icons.warning_amber_outlined, () {
                        Navigator.pushNamed(
                            context, ShortcomingScreen.routeName);
                      }),
                      _buildGridItem("Analysis", Icons.analytics_outlined, () {
                        Navigator.pushNamed(context, AnalysisScreen.routeName);
                      }),
                      _buildGridItem("Purchases", Icons.shopping_bag_outlined,
                          () {
                        Navigator.pushNamed(context, PurchasesScreen.routeName);
                      }),
                      _buildGridItem("Customers", Icons.people_alt_outlined,
                          () {
                        Navigator.pushNamed(context, CustomerScreen.routeName);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
