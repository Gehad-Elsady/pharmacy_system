import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/Screens/customers/widgets/add_customer_form.dart';
import 'package:pharmacy_system/Screens/customers/widgets/customer_view.dart';

class CustomerScreen extends StatelessWidget {
  static const String routeName = 'customer-screen';
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !kIsWeb ? FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.blueGrey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 1),
              ),
              elevation: 10,
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  "Add New Customer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: const AddCustomerForm(),
              ),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ) : null,
        appBar: AppBar(
          title: const Text(
            "Customer Screen",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
                "https://media.istockphoto.com/id/1497445515/photo/i-always-find-everything-i-need-in-my-pharmacy.jpg?s=612x612&w=0&k=20&c=s5OpO66bj3eNgnUlBfm0vpLyw88GkQbng8uj-1fiWdM=",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            kIsWeb? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AddCustomerForm(),
                ),
                Expanded(
                  flex: 1,
                  child: CustomerView(),
                ),
              ],
            ):CustomerView(),
          ],
        ));
  }
}
