import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_system/Screens/Auth/model/usermodel.dart';
import 'package:pharmacy_system/Screens/Employees/model/employee_model.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';
import 'package:pharmacy_system/Screens/purchases/model/purchases_model.dart';

class FirebaseFunctions {
  static SignUp(String emailAddress, String password,
      {required Function onSuccess,
      required Function onError,
      required String userName,
      required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
        age: age,
        email: emailAddress,
        name: userName,
        id: credential.user!.uid,
      );
      addUser(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
    // Callback for unverified email
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      // Check if the user's email is verified
      if (credential.user?.emailVerified ?? false) {
        onSuccess();
      } else {
        onError('Email not verified. Please verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJason(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJason();
      },
    );
  }

  static Future<void> addUser(UserModel user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUserData() async {
    var collection = getUserCollection();

    DocumentSnapshot<UserModel> docUser =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docUser.data();
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }

  static sendRestPassword(String emailAddress) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
  // ---------------------------Add employees----------------------------------

  static CollectionReference<EmployeeModel> getEmployeesCollection() {
    return FirebaseFirestore.instance
        .collection("Employees")
        .withConverter<EmployeeModel>(
      fromFirestore: (snapshot, options) {
        return EmployeeModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addEmployee(EmployeeModel employee) {
    var collection = getEmployeesCollection();
    var docRef = collection.doc(employee.id);
    return docRef.set(employee);
  }

  static createEmployee(
    EmployeeModel employee, {
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: employee.email,
        password: employee.password,
      );
      credential.user?.sendEmailVerification();
      // credential.user?.sendEmailVerification();
      EmployeeModel userModel = EmployeeModel(
        id: credential.user!.uid,
        name: employee.name,
        email: employee.email,
        password: employee.password,
        role: employee.role,
        address: employee.address,
        phoneNumber: employee.phoneNumber,
        experience: employee.experience,
        qualifications: employee.qualifications,
        salary: employee.salary,
        specialization: employee.specialization,
      );

      // Add employee to the database
      await addEmployee(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<EmployeeModel>> getEmployees() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore.collection('Employees').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return EmployeeModel(
            name: data['name'] ?? 'No Name',
            email: data['email'] ?? 'No Email',
            password: data['password'] ?? 'No Password',
            role: data['role'] ?? 'No Role',
            address: data['address'] ?? 'No Address',
            phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
            experience: data['experience'] ?? 'No Experience',
            qualifications: data['qualifications'] ?? 'No Qualifications',
            salary: data['salary'] ?? 'No Salary',
            specialization: data['specialization'] ?? 'No Specialization',
            id: data['userId'] ?? 'No ID',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Future<void> updateEmployee(
      String employeeId, EmployeeModel updatedEmployee) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore
          .collection('Employees')
          .doc(employeeId)
          .update(updatedEmployee.toJson());
      print("Employee updated successfully.");
    } catch (e) {
      print("Error updating employee: $e");
    }
  }

  static Future<void> updateService(
      String email, EmployeeModel updatedData) async {
    // Query to find the document based on `id` and `createdAt`
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Employees')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('Employees')
          .doc(docId)
          .update({
        'name': updatedData.name,
        'role': updatedData.role,
        'address': updatedData.address,
        'phoneNumber': updatedData.phoneNumber,
        'experience': updatedData.experience,
        'qualifications': updatedData.qualifications,
        'salary': updatedData.salary,
        'specialization': updatedData.specialization,
      });
    }
  }

  static Future<void> deleteEmployee(String email, String password) async {
    try {
      // Reference to Firestore
      final firestore = FirebaseFirestore.instance;

      // Query to find the employee in Firestore
      final querySnapshot = await firestore
          .collection('Employees')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the employee from Firestore
        await querySnapshot.docs.first.reference.delete();
        print('Employee deleted from Firestore successfully!');
      } else {
        print('No employee found with the given ID');
        return; // Exit early if no employee found
      }

      // Authenticate and delete the user from Firebase Authentication
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user == null || user.email != email) {
          print(
              'User is not currently signed in. Attempting re-authentication...');

          AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: password);

          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          user = userCredential.user;
        }

        if (user != null) {
          await user.delete();
          print('Employee deleted from Firebase Authentication successfully!');
        } else {
          print('Failed to re-authenticate user.');
        }
      } catch (authError) {
        print('Error deleting user from Firebase Authentication: $authError');
      }
    } catch (e) {
      print('Error deleting Employee: $e');
    }
  }

  // -----------------------------------------Medicines-----------------------------------------------
  static CollectionReference<MedicineModel> getMedicinesCollection() {
    return FirebaseFirestore.instance
        .collection("Medicines")
        .withConverter<MedicineModel>(
      fromFirestore: (snapshot, options) {
        return MedicineModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toMap();
      },
    );
  }

  static Future<void> addMedicine(MedicineModel medicine) {
    var collection = getMedicinesCollection();
    var docRef = collection.doc(medicine.name);
    return docRef.set(medicine);
  }

  //---------------------------------Purchases--------------------------------------------
  static CollectionReference<MedicineModel> getPurchasesCollection() {
    return FirebaseFirestore.instance
        .collection("Purchases")
        .withConverter<MedicineModel>(
      fromFirestore: (snapshot, options) {
        return MedicineModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toMap();
      },
    );
  }

  static Future<void> addMedicinesToPurchases(MedicineModel medicine) {
    var collection = getPurchasesCollection();
    var docRef = collection.doc(); // Generate new document reference

    MedicineModel data = MedicineModel(
      id: docRef.id, // Corrected: Use docRef.id instead of toString()
      name: medicine.name,
      price: medicine.price,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    return docRef.set(data); // Convert object to a Firestore-compatible Map
  }

  static Stream<List<MedicineModel>> getPurchasesData() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore.collection('Purchases').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return MedicineModel(
            name: data['name'] ?? 'No Name',
            price: data['price'] ?? 'No Price',
            id: data['id'] ?? 'No ID',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Future<void> deletePurchaseItem(String medicineId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query Firestore to find the document where 'id' field matches medicineId
      var querySnapshot = await _firestore
          .collection('Purchases')
          .where('id', isEqualTo: medicineId)
          .get();

      // Loop through and delete matching documents
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('Purchases').doc(doc.id).delete();
      }

      print('Item deleted successfully!');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  static Future<void> deleteUserPurchases() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print('No user logged in.');
      return;
    }

    try {
      // Query Firestore to find documents where 'userId' field matches the current user ID
      var querySnapshot = await _firestore
          .collection('Purchases')
          .where('userId', isEqualTo: userId)
          .get();

      // Loop through and delete matching documents
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('Purchases').doc(doc.id).delete();
      }

      print('All purchases for user $userId deleted successfully!');
    } catch (e) {
      print('Error deleting purchases: $e');
    }
  }
//----------------------------------Inventory--------------------------------------------

  static CollectionReference<PurchasesModel> getInventoryCollection() {
    return FirebaseFirestore.instance
        .collection("Inventory")
        .withConverter<PurchasesModel>(
      fromFirestore: (snapshot, options) {
        return PurchasesModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addMedicinesToInventory(PurchasesModel medicine) async {
    var collection = getInventoryCollection();

    // Query for an existing medicine with the same name and expiration date
    var querySnapshot = await collection
        .where("medicineName", isEqualTo: medicine.medicineName)
        .where("medicineExpiryDate", isEqualTo: medicine.medicineExpiryDate)
        .where("medicinePrice", isEqualTo: medicine.medicinePrice)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Medicine exists, update its quantity
      var doc = querySnapshot.docs.first;
      var existingQuantity = doc["medicineQuantity"] ?? 0;
      var newQuantity = existingQuantity + medicine.medicineQuantity;

      await collection.doc(doc.id).update({"medicineQuantity": newQuantity});
    } else {
      // Medicine does not exist, add a new document
      var docRef = collection.doc();
      await docRef.set(medicine);
    }
  }

  static Stream<List<PurchasesModel>> getInventoryData() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore.collection('Inventory').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return PurchasesModel(
            medicineName: data['medicineName'] ?? 'No Name',
            medicineExpiryDate: data['medicineExpiryDate'] ?? 'No Expiry Date',
            medicinePrice: data['medicinePrice'] ?? 'No Price',
            medicineQuantity: data['medicineQuantity'] ?? 'No Quantity',
            dateOfDay: data['dateOfDay'] ?? 'No Date',
            invoiceId: data['invoiceId'] ?? 'No Invoice ID',
            medicineSmallUnit: data['medicineSmallUnit'] ?? 'No Small Unit',
            medicineSmallUnitNumber:
                data['medicineSmallUnitNumber'] ?? 'No Small Unit Number',
            supplierId: data['supplierId'] ?? 'No Supplier ID',
            timeOfDay: data['timeOfDay'] ?? 'No Time',
            totalPrice: data['totalPrice'] ?? 'No Total Price',
            userId: data['userId'] ?? 'No User ID',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  //----------------------------Shortcomings--------------------------------------------
  static Stream<List<PurchasesModel>> getShortcomingsData() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Calculate the date range (now and one month from now)
    DateTime now = DateTime.now();
    DateTime oneMonthFromNow = now.add(Duration(days: 30));

    try {
      return _firestore.collection('Inventory').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) {
              final data = doc.data();

              // Parse the string to DateTime
              DateTime expiryDate =
                  DateTime.tryParse(data['medicineExpiryDate'] ?? '') ??
                      DateTime(2100);

              // Filter medicines with quantity < 5 and expiry date within the next month
              if (data['medicineQuantity'] < 6 ||
                  expiryDate.isBefore(oneMonthFromNow)) {
                return PurchasesModel(
                  medicineName: data['medicineName'] ?? 'No Name',
                  medicineExpiryDate:
                      data['medicineExpiryDate'] ?? 'No Expiry Date',
                  medicinePrice: data['medicinePrice'] ?? 'No Price',
                  medicineQuantity: data['medicineQuantity'] ?? 'No Quantity',
                  dateOfDay: data['dateOfDay'] ?? 'No Date',
                  invoiceId: data['invoiceId'] ?? 'No Invoice ID',
                  medicineSmallUnit:
                      data['medicineSmallUnit'] ?? 'No Small Unit',
                  medicineSmallUnitNumber:
                      data['medicineSmallUnitNumber'] ?? 'No Small Unit Number',
                  supplierId: data['supplierId'] ?? 'No Supplier ID',
                  timeOfDay: data['timeOfDay'] ?? 'No Time',
                  totalPrice: data['totalPrice'] ?? 'No Total Price',
                  userId: data['userId'] ?? 'No User ID',
                );
              } else {
                return null; // Skip items that don't meet the condition
              }
            })
            .where((item) => item != null)
            .cast<PurchasesModel>()
            .toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }
}
