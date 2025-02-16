import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_system/Screens/Employees/model/employee_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class AddEmpoyeeMobile extends StatefulWidget {
  const AddEmpoyeeMobile({super.key});

  @override
  State<AddEmpoyeeMobile> createState() => _AddEmpoyeeMobileState();
}

class _AddEmpoyeeMobileState extends State<AddEmpoyeeMobile> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  final TextEditingController experienceController = TextEditingController();

  final TextEditingController qualificationsController =
      TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? _selectedRoleType;

  final List<String> _roleTypes = ['Pharmacist', 'Accountant', "Admin"];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    specializationController.dispose();
    salaryController.dispose();
    experienceController.dispose();
    qualificationsController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // name and phone
            TextFormField(
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
                  Icons.person,
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
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your phone number";
                }
                return null;
              },
              controller: phoneController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: "Phone",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            // address and specialization
            SizedBox(height: 20),

            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your address";
                }
                return null;
              },
              controller: addressController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                hintText: "Address",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your specialization";
                }
                return null;
              },
              controller: specializationController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                hintText: "specialization",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),

            // salary and experience
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your salary";
                }
                return null;
              },
              controller: salaryController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                hintText: "Salary",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your experience";
                }
                return null;
              },
              controller: experienceController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.white,
                ),
                hintText: "Experience",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),

            // Qualification
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your Qualification";
                }
                return null;
              },
              controller: qualificationsController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                hintText: "Qualification",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),

            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email address";
                }
                return null;
              },
              controller: emailController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white),

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
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
              controller: passwordController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white),
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
              ),
            ),
            SizedBox(height: 20),

            DropdownButtonFormField<String>(
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Service Type',
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
                    color: Colors.black, // Border color when focused
                    width: 2.0, // Border width
                  ),
                ),
              ),
              value: _selectedRoleType,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.white), // White dropdown icon
              dropdownColor: Color.fromARGB(255, 13, 56, 43),
              items: _roleTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoleType = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a service type' : null,
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
                if (nameController!.text.isEmpty ||
                    emailController!.text.isEmpty ||
                    phoneController!.text.isEmpty ||
                    _selectedRoleType == null ||
                    addressController!.text.isEmpty ||
                    passwordController!.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please fill in all required fields.")),
                  );
                  return;
                }

                // Create employee model
                EmployeeModel employee = EmployeeModel(
                  name: nameController!.text,
                  email: emailController!.text,
                  phoneNumber: phoneController!.text,
                  role: _selectedRoleType!,
                  address: addressController!.text,
                  password: passwordController!.text,
                  experience: experienceController!.text,
                  qualifications: qualificationsController!.text,
                  specialization: specializationController!.text,
                  salary: salaryController!.text,
                );

                try {
                  await FirebaseFunctions.createEmployee(
                    employee,
                    onSuccess: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 500,
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset("assets/lottie/created.json"),
                                  SizedBox(height: 16),
                                  Text(
                                    "Please Verify Your Email Address to Login and send an email to change password.",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.pop(context);
                    },
                    onError: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Failed to save employee. Try again!")),
                      );
                    },
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
      ),
    );
  }
}
