import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 9, 212, 134)),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorKey: Get.key,
    );
  }
}