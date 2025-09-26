import 'package:flutter/material.dart';
import 'package:library_management/features/login/start_page.dart';
import 'package:library_management/service/local_storage_service.dart';
import 'package:library_management/service/mongo_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mongo = MongoService();
  await mongo.connect();
  await LocalStorageService().init();
  runApp(MyApp(mongo: mongo));
}

class MyApp extends StatelessWidget {
  final MongoService mongo;
  const MyApp({super.key, required this.mongo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartPage());
  }
}
