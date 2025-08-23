import 'package:flutter/material.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';

import 'currency_formatter.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({Key? key, required this.property, required this.onTap})
    : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Property Type Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getPropertyTypeIcon(property.type),
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              property.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(
                                property.status,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            property.status.displayName.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(property.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Property Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      property.type.displayName.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Address
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${property.address}, ${property.city}, ${property.state} ${property.zipCode}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Property Details Row
              Row(
                children: [
                  // Bedrooms
                  Icon(Icons.bed_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${property.bedrooms}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),

                  // Bathrooms
                  Icon(
                    Icons.bathtub_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${property.bathrooms}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),

                  // Area
                  Icon(
                    Icons.square_foot_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${property.squareFeet.toStringAsFixed(0)} sq ft',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bottom Row - Rent and Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Monthly Rent
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Rent',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(property.monthlyRent),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  // View Details Button
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                    ),
                  ),
                ],
              ),

              // Description Preview (if available)
              if (property.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  property.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
