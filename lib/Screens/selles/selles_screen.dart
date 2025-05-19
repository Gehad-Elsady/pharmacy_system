import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/Screens/customers/customer_screen.dart';
import 'package:pharmacy_system/Screens/customers/model/customer_model.dart';
import 'package:pharmacy_system/Screens/customers/widgets/add_customer_form.dart';
import 'package:pharmacy_system/Screens/selles/widgets/invoice_selles.dart';
import 'package:pharmacy_system/Screens/selles/widgets/medicin_selles.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/providers/sales_provider.dart';
import 'package:pharmacy_system/backend/models/cart_item.dart';
import 'package:pharmacy_system/Screens/purchases/model/purchases_model.dart';

class SellsScreen extends StatefulWidget {
  static const String routeName = '/sells_screen';
  const SellsScreen({super.key});

  @override
  State<SellsScreen> createState() => _SellsScreenState();
}

class _SellsScreenState extends State<SellsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !kIsWeb? Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.blueGrey,
                title: const Text(
                  "Add Medicine To Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  width: 600,
                  child: MedicinSelles(),
                ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
      ):null,
      appBar: AppBar(
        title: const Text(
          'Sales',
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
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:kIsWeb? Row(
        children: [
          // Left side - Medicine List
          Expanded(
            flex: 1,
            child: MedicinSelles(),
          ),
          // Right side - Cart
          Expanded(
            flex: 3,
            child: InvoiceSelles(),
          ),
        ],
      ):InvoiceSelles(),
    );
  }


}
