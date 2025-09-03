import 'package:flutter/material.dart';
import 'app/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  // await di.init();
  //
  // // Initialize database
  // await GetIt.instance<DatabaseService>().initDatabase();
  //
  // // Initialize notifications
  // await GetIt.instance<NotificationService>().initialize();

  runApp(const PropertyMasterApp());
}

