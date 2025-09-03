// lib/features/tenants/presentation/pages/tenants_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
import 'package:property_manager/features/tenants/domain/usecases/delete_tenant.dart';
import 'package:property_manager/features/tenants/domain/usecases/search_tenant.dart';
import 'package:property_manager/features/tenants/presenatation/bloc/tenant_event.dart';
import 'package:property_manager/features/tenants/presenatation/bloc/tenant_state.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/tenant_bloc.dart';
import '../widgets/tenant_card.dart';
import 'add_tenant_page.dart';

class TenantsListPage extends StatefulWidget {
  const TenantsListPage({Key? key}) : super(key: key);

  @override
  State<TenantsListPage> createState() => _TenantsListPageState();
}

class _TenantsListPageState extends State<TenantsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    context.read<TenantBloc>().add(LoadTenants());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tenants',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddTenant(),
            tooltip: 'Add Tenant',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: BlocConsumer<TenantBloc, TenantState>(
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
                  // Reload the list with updated data
                  context.read<TenantBloc>().add(LoadTenants());
                }
              },
              builder: (context, state) {
                if (state is TenantLoading) {
                  return const LoadingWidget();
                } else if (state is TenantError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry:
                        () => context.read<TenantBloc>().add(LoadTenants()),
                  );
                } else if (state is TenantLoaded) {
                  return _buildTenantsList(state);
                } else if (state is TenantOperationSuccess) {
                  return _buildTenantsSuccessList(state.tenants);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTenant,
        child: const Icon(Icons.add),
        tooltip: 'Add New Tenant',
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search tenants by name, email, or phone...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // context.read<TenantBloc>().add(
                          //   const SearchTenants(''),
                          // );
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (query) {
              // context.read<TenantBloc>().add(SearchTenants(query));
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Filter: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  children:
                      _filterOptions.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                              _applyFilter(filter);
                            }
                          },
                          selectedColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color:
                                isSelected
                                    ? Theme.of(context).primaryColor
                                    : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTenantsList(TenantLoaded state) {
    if (state.filteredTenants.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TenantBloc>().add(LoadTenants());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: state.filteredTenants.length,
        itemBuilder: (context, index) {
          final tenant = state.filteredTenants[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TenantCard(
              tenant: tenant,
              onTap: () => _navigateToTenantDetail(tenant),
              onEdit: () => _navigateToEditTenant(tenant),
              onDelete: () => _showDeleteConfirmation(tenant),
              onToggleStatus: () => _toggleTenantStatus(tenant),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTenantsSuccessList(List<Tenant> tenants) {
    if (tenants.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final tenant = tenants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TenantCard(
            tenant: tenant,
            onTap: () => _navigateToTenantDetail(tenant),
            onEdit: () => _navigateToEditTenant(tenant),
            onDelete: () => _showDeleteConfirmation(tenant),
            onToggleStatus: () => _toggleTenantStatus(tenant),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tenants found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first tenant to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToAddTenant,
            icon: const Icon(Icons.add),
            label: const Text('Add Tenant'),
          ),
        ],
      ),
    );
  }

  void _applyFilter(String filter) {
    switch (filter) {
      case 'Active':
        context.read<TenantBloc>().add(const FilterTenants(isActive: true));
        break;
      case 'Inactive':
        context.read<TenantBloc>().add(const FilterTenants(isActive: false));
        break;
      default:
        context.read<TenantBloc>().add(const FilterTenants());
        break;
    }
  }

  void _navigateToAddTenant() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddTenantPage()));
  }

  void _navigateToTenantDetail(Tenant tenant) {
    // Navigate to tenant detail page
    Navigator.of(context).pushNamed('/tenant-detail', arguments: tenant);
  }

  void _navigateToEditTenant(Tenant tenant) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddTenantPage(tenant: tenant)),
    );
  }

  void _showDeleteConfirmation(Tenant tenant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Tenant'),
          content: Text(
            'Are you sure you want to delete ${tenant.fullName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //  context.read<TenantBloc>().add(DeleteTenant(tenant.id!));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTenantStatus(Tenant tenant) {
    if (tenant.isActive) {
      context.read<TenantBloc>().add(DeactivateTenant(tenant.id!));
    } else {
      context.read<TenantBloc>().add(ActivateTenant(tenant.id!));
    }
  }
}
