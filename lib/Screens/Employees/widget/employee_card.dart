import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Employees/model/employee_model.dart';
import 'package:pharmacy_system/Screens/Employees/widget/update_employee.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class EmployeeCard extends StatefulWidget {
  EmployeeCard({
    super.key,
  });

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
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
            hintText: "Search for Employees...",
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
            stream: _firestore.collection('Employees').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Employees found."));
              }

              final results = snapshot.data!.docs.where((doc) {
                final name = doc['name'].toString().toLowerCase();
                final type = doc['role'].toString().toLowerCase();
                return name.contains(query) || type.contains(query);
              }).toList();

              if (results.isEmpty) {
                return const Center(child: Text("No matching services found."));
              }

              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final model = results[index];
                  final employee = EmployeeModel.fromJson(
                      model.data() as Map<String, dynamic>);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Basic Information",
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
                                  text: 'Employee Name : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.name,
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
                                  text: 'Employee Address : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.address,
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
                                  text: 'Employee Phone Number : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.phoneNumber,
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
                                  text: 'Employee Name : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.name,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Text(
                            "Qualifications",
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
                                  text: 'Qualifications : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.qualifications,
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
                                  text: 'Experience : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.experience + 'Years',
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
                                  text: 'Employee Role : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.role,
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
                                  text: 'Employee Specialization : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.specialization,
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
                                  text: 'Employee Salary : ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: employee.salary,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Text(
                            "User name Ditails",
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
                          kIsWeb
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Username : ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: employee.email,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 15,
                                        shadowColor: Color(0xff212529),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text(
                                                    'Send Password Reset Link To User'),
                                                content: Text(
                                                    'Are you sure you want to send password reset link to user?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                      child: Text('Send'),
                                                      onPressed: () {
                                                        // Send password reset link to user
                                                        FirebaseFunctions
                                                            .sendRestPassword(
                                                                employee.email);
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Password Reset Link Sent'),
                                                              );
                                                            });
                                                      })
                                                ]);
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Send Reset Password Link",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Username : \n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: employee.email,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(15),
                                        elevation: 15,
                                        shadowColor: Color(0xff212529),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text(
                                                    'Send Password Reset Link To User'),
                                                content: Text(
                                                    'Are you sure you want to send password reset link to user?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                      child: Text('Send'),
                                                      onPressed: () {
                                                        // Send password reset link to user
                                                        FirebaseFunctions
                                                            .sendRestPassword(
                                                                employee.email);
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Password Reset Link Sent'),
                                                              );
                                                            });
                                                      })
                                                ]);
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Send Reset Password Link",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.blueGrey,
                                          title: Text(
                                            "Update Employee Details",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Container(
                                              // color: Colors.grey,
                                              // height: 200,
                                              width: 600,
                                              child: UpdateEmployeeForm(
                                                employeeModel: employee,
                                              )));
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  elevation: 15,
                                  shadowColor: Color(0xff212529),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Update Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Delete Employee",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: const Text(
                                          "Are you sure you want to delete this employee?",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .pop(); // Close dialog first
                                              try {
                                                // Show a loading indicator while deleting

                                                await FirebaseFunctions
                                                    .deleteEmployee(
                                                        employee.email,
                                                        employee.password);

                                                Navigator.of(context)
                                                    .pop(); // Close loading dialog
                                              } catch (e) {
                                                Navigator.of(context)
                                                    .pop(); // Close loading dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text("Error"),
                                                      content: Text(
                                                          "Failed to delete employee: $e"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child:
                                                              const Text("OK"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  elevation: 15,
                                  shadowColor: const Color(0xff212529),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Delete Employee",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
