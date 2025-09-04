// lib/features/tenants/presentation/widgets/address_history_widget.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';

class AddressHistoryWidget extends StatelessWidget {
  final List<AddressHistory> addresses;

  const AddressHistoryWidget({Key? key, required this.addresses})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        final isCurrent = address.validTo == null;

        return _buildAddressCard(context, address, isCurrent);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No address history',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Address changes will be tracked here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressHistory address,
    bool isCurrent,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCurrent ? Icons.home : Icons.location_on_outlined,
                  color: isCurrent ? Colors.green : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  _formatDateRange(address.validFrom, address.validTo),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address.address,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            if (address.city != null ||
                address.state != null ||
                address.zipCode != null) ...[
              const SizedBox(height: 4),
              Text(
                [
                  address.city,
                  address.state,
                  address.zipCode,
                ].where((e) => e != null && e.isNotEmpty).join(', '),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
            if (address.country != null && address.country!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                address.country!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTime validFrom, DateTime? validTo) {
    final fromStr = '${validFrom.day}/${validFrom.month}/${validFrom.year}';
    if (validTo == null) {
      return '$fromStr - Present';
    }
    final toStr = '${validTo.day}/${validTo.month}/${validTo.year}';
    return '$fromStr - $toStr';
  }
}
