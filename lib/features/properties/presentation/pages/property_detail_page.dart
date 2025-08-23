import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';
import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';
import 'package:property_manager/shared/widgets/custom_app_bar.dart';
import 'package:property_manager/shared/widgets/loading_widget.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import 'add_property_page.dart';

class PropertyDetailPage extends StatefulWidget {
  final Property property;

  const PropertyDetailPage({Key? key, required this.property})
    : super(key: key);

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Property currentProperty;

  @override
  void initState() {
    super.initState();
    currentProperty = widget.property;
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.available:
        return Colors.green;
      case PropertyStatus.occupied:
        return Colors.blue;
      case PropertyStatus.maintenance:
        return Colors.orange;
      case PropertyStatus.renovating:
        return Colors.red;
    }
  }

  IconData _getPropertyTypeIcon(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return Icons.apartment;
      case PropertyType.house:
        return Icons.house;
      case PropertyType.condo:
        return Icons.home_work;
      case PropertyType.townhouse:
        return Icons.location_city;
      case PropertyType.studio:
        return Icons.single_bed;
      case PropertyType.commercial:
        return Icons.business;
    }
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Property'),
            content: Text(
              'Are you sure you want to delete "${currentProperty.name}"?\n\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteProperty();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _deleteProperty() {
    if (currentProperty.id != null) {
      context.read<PropertyBloc>().add(
        DeletePropertyEvent(currentProperty.id!),
      );
    }
  }

  void _navigateToEditProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyPage(property: currentProperty),
      ),
    );

    if (result == true) {
      // Navigate back to properties list
      Navigator.pop(context, true);
    }
  }

  void _showStatusUpdateDialog() {
    final statuses = PropertyStatus.values;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Property Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  statuses.map((status) {
                    return RadioListTile<PropertyStatus>(
                      title: Text(status.displayName),
                      value: status,
                      groupValue: currentProperty.status,
                      onChanged: (value) {
                        Navigator.pop(context);
                        if (value != null) {
                          _updatePropertyStatus(value.displayName);
                        }
                      },
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _updatePropertyStatus(String newStatus) {
    if (currentProperty.id != null) {
      context.read<PropertyBloc>().add(
        UpdatePropertyStatusEvent(currentProperty.id!, newStatus),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: currentProperty.name,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _navigateToEditProperty();
                  break;
                case 'status':
                  _showStatusUpdateDialog();
                  break;
                case 'delete':
                  _showDeleteConfirmDialog();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit Property'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(Icons.update),
                        SizedBox(width: 8),
                        Text('Update Status'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete Property',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: BlocListener<PropertyBloc, PropertyState>(
        listener: (context, state) {
          if (state is PropertyDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Property deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PropertyUpdated ||
              state is PropertyStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Property updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh the current property data
            if (currentProperty.id != null) {
              context.read<PropertyBloc>().add(
                GetPropertyEvent(currentProperty.id!),
              );
            }
          } else if (state is PropertyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PropertyLoaded) {
            // Update current property with fresh data
            setState(() {
              currentProperty = state.property;
            });
          }
        },
        child: BlocBuilder<PropertyBloc, PropertyState>(
          builder: (context, state) {
            if (state is PropertyLoading) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getPropertyTypeIcon(currentProperty.type),
                                  color: theme.primaryColor,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentProperty.name,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          currentProperty.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getStatusColor(
                                            currentProperty.status,
                                          ).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        currentProperty.status.displayName
                                            .toUpperCase(),
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: _getStatusColor(
                                                currentProperty.status,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Monthly Rent',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(
                                    currentProperty.monthlyRent,
                                  ),
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Property Details Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Property Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address
                          _DetailRow(
                            icon: Icons.location_on_outlined,
                            label: 'Address',
                            value:
                                '${currentProperty.address}\n${currentProperty.city}, ${currentProperty.state} ${currentProperty.zipCode}',
                          ),

                          // Property Type
                          _DetailRow(
                            icon: Icons.home_outlined,
                            label: 'Property Type',
                            value: currentProperty.type.displayName,
                          ),

                          // Bedrooms
                          _DetailRow(
                            icon: Icons.bed_outlined,
                            label: 'Bedrooms',
                            value: currentProperty.bedrooms.toString(),
                          ),

                          // Bathrooms
                          _DetailRow(
                            icon: Icons.bathtub_outlined,
                            label: 'Bathrooms',
                            value: currentProperty.bathrooms.toString(),
                          ),

                          // Area
                          _DetailRow(
                            icon: Icons.square_foot_outlined,
                            label: 'Area',
                            value:
                                '${currentProperty.squareFeet.toStringAsFixed(0)} sq ft',
                          ),

                          // Security Deposit
                          _DetailRow(
                            icon: Icons.security_outlined,
                            label: 'Security Deposit',
                            value: CurrencyFormatter.format(
                              currentProperty.securityDeposit,
                            ),
                          ),

                          // Amenities
                          if (currentProperty.amenities.isNotEmpty)
                            _DetailRow(
                              icon: Icons.star_outline,
                              label: 'Amenities',
                              value: currentProperty.amenities.join(', '),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Description Card
                  if (currentProperty.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentProperty.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 80), // Space for floating buttons
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: _navigateToEditProperty,
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            heroTag: 'edit',
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: _showStatusUpdateDialog,
            icon: const Icon(Icons.update),
            label: const Text('Update Status'),
            heroTag: 'status',
            backgroundColor: _getStatusColor(currentProperty.status),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
