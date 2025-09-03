// lib/features/tenants/presentation/pages/add_tenant_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/tenants/presenatation/bloc/tenant_state.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/tenant.dart';
import '../bloc/tenant_bloc.dart';
import '../widgets/tenant_form.dart';

class AddTenantPage extends StatelessWidget {
  final Tenant? tenant;
  final List<Map<String, String>>? availableProperties;

  const AddTenantPage({Key? key, this.tenant, this.availableProperties})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tenant == null ? 'Add Tenant' : 'Edit Tenant',
        showBackButton: true,
      ),
      body: BlocConsumer<TenantBloc, TenantState>(
        listener: (context, state) {
          if (state is TenantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TenantOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
          }
        },
        builder: (context, state) {
          if (state is TenantLoading) {
            return const LoadingWidget();
          }

          return TenantForm(
            tenant: tenant,
            availableProperties: availableProperties ?? _getDefaultProperties(),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getDefaultProperties() {
    // This would typically come from a properties bloc or repository
    // For now, returning empty list - you can inject this dependency
    return [];
  }
}
