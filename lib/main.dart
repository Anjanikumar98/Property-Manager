import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'app/app.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_service.dart';
import 'package:injectable/injectable.dart' as di;

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
