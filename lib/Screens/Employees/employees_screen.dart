import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Employees/widget/add_employee_form.dart';
import 'package:pharmacy_system/Screens/Employees/widget/employee_card.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';

class EmployeesScreen extends StatefulWidget {
  static const String routeName = "EmployeesScreen";

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
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
                          "Add Employee Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                            // color: Colors.grey,
                            height: double.infinity,
                            width: double.infinity,
                            child: SingleChildScrollView(
                                child: AddEmployeeForm())));
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
                "Add Employee",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Employees Screen",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.blue)),
        elevation: 0,
      ),
      body: kIsWeb
          ? Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    "https://plus.unsplash.com/premium_photo-1661776255948-7a76baa9d7b9?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: AddEmployeeForm()),
                    Expanded(flex: 1, child: EmployeeCard()),
                  ],
                ),
              ],
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    "https://plus.unsplash.com/premium_photo-1661776255948-7a76baa9d7b9?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                EmployeeCard(),
              ],
            ),
    );
  }
}
