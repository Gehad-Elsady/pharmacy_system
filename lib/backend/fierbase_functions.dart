import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_system/Screens/Auth/model/usermodel.dart';
import 'package:pharmacy_system/Screens/Employees/model/employee_model.dart';
import 'package:pharmacy_system/Screens/customers/model/customer_model.dart';
import 'package:pharmacy_system/Screens/medicines/model/medicine_model.dart';
import 'package:pharmacy_system/Screens/purchases/model/purchases_model.dart';
import 'package:pharmacy_system/backend/models/cart_model.dart';
import 'package:pharmacy_system/backend/models/cart_item.dart';

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

static Future<void> Login(
  String emailAddress,
  String password, {
  required void Function() onSuccess,
  required void Function(String) onError,
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
    onError(e.message ?? 'An unknown error occurred');
  } catch (e) {
    onError('Something went wrong. Please try again.');
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

  //----------------------------------Cart--------------------------------------------
  static CollectionReference<CartModel> getCartCollection() {
    return FirebaseFirestore.instance
        .collection("Cart")
        .withConverter<CartModel>(
      fromFirestore: (snapshot, options) {
        return CartModel.fromJson(snapshot.data()!);
      },
      toFirestore: (cart, _) {
        return cart.toJson();
      },
    );
  }

  static Future<void> saveCart(
      List<CartItem> items, double total, String customerPhoneNumber) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('No user logged in');

      final cartModel = CartModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        items: items,
        total: total,
        createdAt: DateTime.now(),
        customerPhoneNumber: customerPhoneNumber,
      );

      await getCartCollection().doc().set(cartModel);
    } catch (e) {
      print('Error saving cart: $e');
      rethrow;
    }
  }

  static Stream<List<CartModel>> getUserCarts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return getCartCollection()
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  static Future<void> deleteCart(String cartId) async {
    try {
      await getCartCollection().doc(cartId).delete();
    } catch (e) {
      print('Error deleting cart: $e');
      rethrow;
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

  static Future<void> updateMedicinesInInventory(
      List<CartItem> medicines) async {
    var collection = getInventoryCollection();

    for (var item in medicines) {
      print(
          "Looking for: ${item.medicineName}, ${item.expiryDate}, ${item.price}");

      var querySnapshot = await collection
          .where("medicineName", isEqualTo: item.medicineName)
          .where("medicineExpiryDate", isEqualTo: item.expiryDate)
          .where("medicinePrice", isEqualTo: item.price.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var existingMedicine = doc.data();
        var existingQuantity = existingMedicine.medicineQuantity ?? 0;

        int quantityToSubtract = 0;
        if (item.selectedUnit == "strip") {
          quantityToSubtract = item.quantity;
        } else if (item.selectedUnit == "unit") {
          quantityToSubtract = (item.quantity / item.smallUnitNumber).ceil();
        }

        int newQuantity = existingQuantity - quantityToSubtract;
        if (newQuantity < 0) newQuantity = 0;

        print("Updating quantity from $existingQuantity to $newQuantity");

        await collection.doc(doc.id).update({"medicineQuantity": newQuantity});
      } else {
        print("No matching document found for ${item.medicineName}");
      }
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

  //----------------------------------Customers--------------------------------------------
  static CollectionReference<CustomerModel> getCustomersCollection() {
    return FirebaseFirestore.instance
        .collection("Customers")
        .withConverter<CustomerModel>(
      fromFirestore: (snapshot, options) {
        return CustomerModel.fromMap(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toMap();
      },
    );
  }

  static Future<void> addCustomer(CustomerModel employee) {
    var collection = getCustomersCollection();
    var docRef = collection.doc();
    return docRef.set(employee);
  }

  static Stream<List<CustomerModel>> getCustomers() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore.collection('Customers').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return CustomerModel(
            name: data['name'] ?? 'No Name',
            email: data['email'] ?? 'No Email',
            address: data['address'] ?? 'No Address',
            phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
            age: data['age'] ?? 'No Age',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<CustomerModel?> getCustomerToCheckOut(String phoneNumber) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      return _firestore
          .collection('Customers')
          .where("phoneNumber", isEqualTo: phoneNumber)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          return CustomerModel(
            name: data['name'] ?? 'No Name',
            email: data['email'] ?? 'No Email',
            address: data['address'] ?? 'No Address',
            phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
            age: data['age'] ?? 'No Age',
          );
        } else {
          return null; // No customer found
        }
      });
    } catch (e) {
      print('Error fetching customer: $e');
      return const Stream.empty(); // Return empty stream on error
    }
  }

  static Stream<List<CartModel>> getUserCartsHistory(String phoneNumber) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('Cart')
        .where("customerPhoneNumber", isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              final data = doc.data();
              print(data);

              // Handle both int and double for total field
              final total = data['total'] is int
                  ? (data['total'] as int).toDouble()
                  : data['total'] as double;

              return CartModel(
                id: data['id'] as String,
                userId: data['userId'] as String,
                items: (data['items'] as List)
                    .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
                    .toList(),
                total: total,
                createdAt: (data['createdAt'] as Timestamp).toDate(),
                customerPhoneNumber: data['customerPhoneNumber'] as String,
              );
            } catch (e) {
              print('Error processing cart document: $e');
              rethrow;
            }
          }).toList();
        })
        .handleError((e) {
          print('Error fetching cart history: $e');
        });
  }

  //-----------------------------------Analytics-------------------------------------------

  static Stream<List<CartModel>> cartsHistory() {
    return getCartCollection()
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  static Future<double> getMonthlyProfit() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final snapshot = await FirebaseFirestore.instance
        .collection('Cart') // replace with your actual collection name
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('createdAt', isLessThan: Timestamp.fromDate(endOfMonth))
        .get();

    final carts =
        snapshot.docs.map((doc) => CartModel.fromJson(doc.data())).toList();

    double totalProfit = carts.fold(0.0, (sum, cart) => sum + cart.total);
    return totalProfit;
  }

  static Future<String> getUserName(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data()?['name'] ?? 'Unknown';
  }

  static Future<Map<String, String>> getAllUserNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Employees').get();
    final Map<String, String> names = {};
    for (var doc in snapshot.docs) {
      names[doc.id] = doc.data()['name'] ?? 'Unknown';
    }
    return names;
  }
}
