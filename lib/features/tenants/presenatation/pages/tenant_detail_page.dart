// lib/features/tenants/presentation/pages/tenant_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/entities/tenant.dart';
import 'add_tenant_page.dart';

class TenantDetailPage extends StatelessWidget {
  final Tenant tenant;

  const TenantDetailPage({Key? key, required this.tenant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tenant.fullName,
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
            tooltip: 'Edit Tenant',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),
            _buildPersonalInfoCard(context),
            const SizedBox(height: 16),
            _buildContactInfoCard(context),
            if (tenant.emergencyContactName != null ||
                tenant.emergencyContactPhone != null) ...[
              const SizedBox(height: 16),
              _buildEmergencyContactCard(context),
            ],
            const SizedBox(height: 16),
            _buildAdditionalInfoCard(context),
            if (tenant.propertyIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildPropertiesCard(context),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEdit(context),
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  tenant.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              child: Text(
                tenant.firstName.isNotEmpty && tenant.lastName.isNotEmpty
                    ? '${tenant.firstName[0]}${tenant.lastName[0]}'
                        .toUpperCase()
                    : 'T',
                style: TextStyle(
                  color: tenant.isActive ? Colors.green[700] : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          tenant.isActive
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tenant.isActive ? 'Active Tenant' : 'Inactive Tenant',
                      style: TextStyle(
                        color:
                            tenant.isActive
                                ? Colors.green[700]
                                : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (tenant.occupation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      tenant.occupation!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (tenant.dateOfBirth != null)
              _buildInfoRow(
                context,
                Icons.cake,
                'Date of Birth',
                _formatDate(tenant.dateOfBirth!),
              ),
            if (tenant.idNumber != null)
              _buildInfoRow(
                context,
                Icons.badge,
                'ID Number',
                tenant.idNumber!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildClickableInfoRow(
              context,
              Icons.email,
              'Email',
              tenant.email,
              onTap: () => _copyToClipboard(context, tenant.email, 'Email'),
            ),
            _buildClickableInfoRow(
              context,
              Icons.phone,
              'Phone',
              tenant.phone,
              onTap: () => _copyToClipboard(context, tenant.phone, 'Phone'),
            ),
            if (tenant.address != null)
              _buildInfoRow(
                context,
                Icons.location_on,
                'Address',
                tenant.address!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Contact',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (tenant.emergencyContactName != null)
              _buildInfoRow(
                context,
                Icons.contact_emergency,
                'Name',
                tenant.emergencyContactName!,
              ),
            if (tenant.emergencyContactPhone != null)
              _buildClickableInfoRow(
                context,
                Icons.phone_in_talk,
                'Phone',
                tenant.emergencyContactPhone!,
                onTap:
                    () => _copyToClipboard(
                      context,
                      tenant.emergencyContactPhone!,
                      'Emergency contact phone',
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (tenant.monthlyIncome != null)
              _buildInfoRow(
                context,
                Icons.attach_money,
                'Monthly Income',
                '\$${tenant.monthlyIncome!.toStringAsFixed(2)}',
                valueColor: Colors.green[600],
              ),
            if (tenant.notes != null)
              _buildInfoRow(context, Icons.note, 'Notes', tenant.notes!),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Added',
              _formatDate(tenant.createdAt),
            ),
            if (tenant.updatedAt != tenant.createdAt)
              _buildInfoRow(
                context,
                Icons.update,
                'Last Updated',
                _formatDate(tenant.updatedAt),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigned Properties',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${tenant.propertyIds.length} ${tenant.propertyIds.length == 1 ? 'Property' : 'Properties'} assigned',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            // You would typically fetch property details here
            // For now, just showing the IDs
            ...tenant.propertyIds.map(
              (propertyId) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.home, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text('Property ID: $propertyId'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Icon(Icons.copy, size: 16, color: Colors.grey[500]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyToClipboard(BuildContext context, String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AddTenantPage(tenant: tenant),
          ),
        )
        .then((result) {
          if (result == true) {
            // Refresh the tenant data if needed
            Navigator.of(context).pop(true);
          }
        });
  }
}
