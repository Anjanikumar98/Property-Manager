import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PropertyMasterApp extends StatelessWidget {
  const PropertyMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthBloc>(create: (context) => GetIt.instance<AuthBloc>()),
        // BlocProvider<PropertyBloc>(
        //   create: (context) => GetIt.instance<PropertyBloc>(),
        // ),
        // BlocProvider<TenantBloc>(
        //   create: (context) => GetIt.instance<TenantBloc>(),
        // ),
        // BlocProvider<LeaseBloc>(
        //   create: (context) => GetIt.instance<LeaseBloc>(),
        // ),
        // BlocProvider<PaymentBloc>(
        //   create: (context) => GetIt.instance<PaymentBloc>(),
        // ),
        // BlocProvider<DashboardBloc>(
        //   create:
        //       (context) =>
        //           GetIt.instance<DashboardBloc>()..add(LoadDashboard()),
        // ),
        // BlocProvider<ReportBloc>(
        //   create: (context) => GetIt.instance<ReportBloc>(),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Property Master',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
