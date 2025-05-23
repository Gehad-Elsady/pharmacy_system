import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/Screens/analysis/analysis_screen.dart';
import 'package:pharmacy_system/Screens/customers/customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_system/Screens/Auth/Signup_screen.dart';
import 'package:pharmacy_system/Screens/Auth/login_screen.dart';
import 'package:pharmacy_system/Screens/Employees/employees_screen.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/Screens/inventory/inventory_screen.dart';
import 'package:pharmacy_system/Screens/medicines/add_medicine_screen.dart';
import 'package:pharmacy_system/Screens/purchases/purchases_screen.dart';
import 'package:pharmacy_system/Screens/selles/selles_screen.dart';
import 'package:pharmacy_system/Screens/shortcoming/shortcoming_screen.dart';
import 'package:pharmacy_system/backend/firebase_options.dart';
import 'package:pharmacy_system/backend/providers/sales_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => SalesProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: LoginScreen.routeName,
              routes: {
                LoginScreen.routeName: (context) => LoginScreen(),
                SignupScreen.routeName: (context) => SignupScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                EmployeesScreen.routeName: (context) => EmployeesScreen(),
                AddMedicineScreen.routeName: (context) => AddMedicineScreen(),
                InventoryScreen.routeName: (context) => InventoryScreen(),
                PurchasesScreen.routeName: (context) => PurchasesScreen(),
                ShortcomingScreen.routeName: (context) => ShortcomingScreen(),
                SellsScreen.routeName: (context) => SellsScreen(),
                CustomerScreen.routeName: (context) => CustomerScreen(),
                AnalysisScreen.routeName: (context) => AnalysisScreen(),
              },
            ),
          );
        });
  }
}
