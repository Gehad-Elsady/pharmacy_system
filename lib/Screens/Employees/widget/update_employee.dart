// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Employees/model/employee_model.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';

class UpdateEmployeeForm extends StatefulWidget {
  UpdateEmployeeForm({super.key, this.employeeModel});

  final EmployeeModel? employeeModel;

  @override
  State<UpdateEmployeeForm> createState() => _UpdateEmployeeFormState();
}

class _UpdateEmployeeFormState extends State<UpdateEmployeeForm> {
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
  void initState() {
    super.initState();

    // Populate controllers if employeeModel is not null
    if (widget.employeeModel != null) {
      nameController.text = widget.employeeModel!.name ?? '';
      phoneController.text = widget.employeeModel!.phoneNumber ?? '';
      addressController.text = widget.employeeModel!.address ?? '';
      specializationController.text =
          widget.employeeModel!.specialization ?? '';
      salaryController.text = widget.employeeModel!.salary?.toString() ?? '';
      experienceController.text = widget.employeeModel!.experience ?? '';
      qualificationsController.text =
          widget.employeeModel!.qualifications ?? '';
      emailController.text = widget.employeeModel!.email ?? '';
      passwordController.text = widget.employeeModel!.password ?? '';
      _selectedRoleType = widget.employeeModel!.role ?? _roleTypes.first;
      print(
          "-----------------------------------------------------------${widget.employeeModel!.id}");
    }
  }

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
        child: kIsWeb
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // name and phone
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: nameController,
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: "Name",
                          errorMessage: "Please enter your name",
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MyTextField(
                          controller: phoneController,
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          hintText: "Phone",
                          errorMessage: "Please enter your phone number",
                        ),
                      ),
                    ],
                  ),
                  // address and specialization
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: addressController,
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          hintText: "Address",
                          errorMessage: "Please enter your address",
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MyTextField(
                          controller: specializationController,
                          icon: Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          hintText: "specialization",
                          errorMessage: "Please enter your specialization",
                        ),
                      ),
                    ],
                  ),
                  // salary and experience
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: salaryController,
                          icon: Icon(
                            Icons.money,
                            color: Colors.white,
                          ),
                          hintText: "Salary",
                          errorMessage: "Please enter your salary",
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MyTextField(
                          controller: experienceController,
                          icon: Icon(
                            Icons.numbers,
                            color: Colors.white,
                          ),
                          hintText: "Experience",
                          errorMessage: "Please enter your experience",
                        ),
                      ),
                    ],
                  ),
                  // Qualification
                  MyTextField(
                    controller: qualificationsController,
                    icon: Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                    hintText: "Qualifications",
                    errorMessage: "please enter your qualifications",
                  ),
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
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          _selectedRoleType == null ||
                          addressController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please fill in all required fields.")),
                        );
                        return;
                      }

                      // Create employee model
                      EmployeeModel employee = EmployeeModel(
                        name: nameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        role: _selectedRoleType!,
                        address: addressController.text,
                        password: passwordController.text,
                        experience: experienceController.text,
                        qualifications: qualificationsController.text,
                        specialization: specializationController.text,
                        salary: salaryController.text,
                      );
                      print(
                          "-------------******************---------------${nameController.text}");
                      try {
                        await FirebaseFunctions.updateService(
                            widget.employeeModel!.email!, employee);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Employee updated successfully.")),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                    child: Text(
                      "Upate Employee",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            // ------------------------------------------Mobile View--------------------------------------------------
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // name and phone
                    MyTextField(
                      controller: nameController,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "Name",
                      errorMessage: "Please enter your name",
                    ),

                    SizedBox(height: 20),
                    MyTextField(
                      controller: phoneController,
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      hintText: "Phone",
                      errorMessage: "Please enter your phone number",
                    ),

                    // address and specialization
                    SizedBox(height: 20),
                    MyTextField(
                      controller: addressController,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      hintText: "Address",
                      errorMessage: "Please enter your address",
                    ),

                    SizedBox(height: 20),
                    MyTextField(
                      controller: specializationController,
                      icon: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      hintText: "specialization",
                      errorMessage: "Please enter your specialization",
                    ),

                    SizedBox(height: 20),

                    // salary and experience
                    MyTextField(
                      controller: salaryController,
                      icon: Icon(
                        Icons.money,
                        color: Colors.white,
                      ),
                      hintText: "Salary",
                      errorMessage: "Please enter your salary",
                    ),

                    SizedBox(height: 20),
                    MyTextField(
                      controller: experienceController,
                      icon: Icon(
                        Icons.numbers,
                        color: Colors.white,
                      ),
                      hintText: "Experience",
                      errorMessage: "Please enter your experience",
                    ),

                    SizedBox(height: 20),

                    // Qualification
                    MyTextField(
                      controller: qualificationsController,
                      icon: Icon(
                        Icons.school,
                        color: Colors.white,
                      ),
                      hintText: "Qualifications",
                      errorMessage: "please enter your qualifications",
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
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            _selectedRoleType == null ||
                            addressController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Please fill in all required fields.")),
                          );
                          return;
                        }

                        // Create employee model
                        EmployeeModel employee = EmployeeModel(
                          name: nameController.text,
                          email: emailController.text,
                          phoneNumber: phoneController.text,
                          role: _selectedRoleType!,
                          address: addressController.text,
                          password: passwordController.text,
                          experience: experienceController.text,
                          qualifications: qualificationsController.text,
                          specialization: specializationController.text,
                          salary: salaryController.text,
                        );

                        try {
                          await FirebaseFunctions.updateService(
                              widget.employeeModel!.email, employee);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Employee updated successfully.")),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      },
                      child: Text(
                        "Upate Employee",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.errorMessage,
  });

  final TextEditingController controller;
  String errorMessage;
  String hintText;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.blue, // Border color when focused
            width: 2.0, // Border width
          ),
        ),
        prefixIcon: icon,
        hintText: hintText,
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
    );
  }
}
