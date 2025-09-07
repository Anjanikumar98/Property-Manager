// lib/features/leases/presentation/pages/lease_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/lease.dart';
import '../bloc/lease_bloc.dart';
import '../bloc/lease_event.dart';
import '../bloc/lease_state.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/custom_button.dart';

class LeaseDetailPage extends StatelessWidget {
  final Lease lease;

  const LeaseDetailPage({Key? key, required this.lease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lease Details',
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Lease'),
                    ),
                  ),
                  if (lease.status == LeaseStatus.active) ...[
                    const PopupMenuItem(
                      value: 'renew',
                      child: ListTile(
                        leading: Icon(Icons.refresh),
                        title: Text('Renew Lease'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'terminate',
                      child: ListTile(
                        leading: Icon(Icons.stop_circle),
                        title: Text('Terminate Lease'),
                      ),
                    ),
                  ],
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text(
                        'Delete Lease',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: BlocListener<LeaseBloc, LeaseState>(
        listener: (context, state) {
          if (state is LeaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LeaseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('deleted')) {
              Navigator.of(context).pop();
            }
          }
        },
        child: BlocBuilder<LeaseBloc, LeaseState>(
          builder: (context, state) {
            if (state is LeaseLoading) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildDetailsCard(),
                  const SizedBox(height: 16),
                  _buildFinancialCard(),
                  const SizedBox(height: 16),
                  _buildProgressCard(),
                  const SizedBox(height: 16),
                  if (lease.specialTerms?.isNotEmpty == true ||
                      lease.notes?.isNotEmpty == true) ...[
                    _buildAdditionalInfoCard(),
                    const SizedBox(height: 16),
                  ],
                  if (lease.attachments.isNotEmpty) ...[
                    _buildAttachmentsCard(),
                    const SizedBox(height: 16),
                  ],
                  _buildActionButtons(context),
                  const SizedBox(height: 16),
                  //  LeaseHistoryWidget(leaseId: lease.id),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lease.propertyName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tenant: ${lease.tenantName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                //   LeaseStatusBadge(status: lease.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Lease Type',
                    _formatLeaseType(lease.leaseType),
                    Icons.home,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Rent Frequency',
                    _formatRentFrequency(lease.rentFrequency),
                    Icons.schedule,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lease Period',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Start Date',
                    dateFormatter.format(lease.startDate),
                    Icons.play_arrow,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'End Date',
                    dateFormatter.format(lease.endDate),
                    Icons.stop,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Total Days',
                    '${lease.totalDays} days',
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Remaining Days',
                    '${lease.remainingDays} days',
                    Icons.timer,
                    isWarning: lease.isExpiringSoon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              'Notice Period',
              '${lease.noticePeriodDays} days',
              Icons.notification_important,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard() {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Monthly Rent',
                    currencyFormatter.format(lease.monthlyRent),
                    Icons.payments,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Security Deposit',
                    currencyFormatter.format(lease.securityDeposit),
                    Icons.security,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Rent per ${_formatRentFrequency(lease.rentFrequency)}',
                    currencyFormatter.format(lease.rentPerFrequency),
                    Icons.calculate,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Total Rent Amount',
                    currencyFormatter.format(lease.totalRentAmount),
                    Icons.monetization_on,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lease Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(lease.progressPercentage * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: lease.progressPercentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                lease.isExpiringSoon ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            if (lease.isExpiringSoon)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This lease is expiring soon. Consider renewal or termination.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (lease.specialTerms?.isNotEmpty == true) ...[
              const Text(
                'Special Terms',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(lease.specialTerms!),
              const SizedBox(height: 16),
            ],
            if (lease.notes?.isNotEmpty == true) ...[
              const Text(
                'Notes',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(lease.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...lease.attachments.map(
              (attachment) => ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(attachment),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadAttachment(attachment),
                ),
                onTap: () => _viewAttachment(attachment),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Edit Lease',
                    onPressed: () => _editLease(context),
                    //     backgroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                if (lease.status == LeaseStatus.active) ...[
                  Expanded(
                    child: CustomButton(
                      text: 'Renew',
                      onPressed: () => _showRenewalDialog(context),
                      //    backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'Terminate',
                      onPressed: () => _showTerminationDialog(context),
                      //   backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon, {
    bool isWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isWarning ? Colors.orange : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isWarning ? Colors.orange : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        _editLease(context);
        break;
      case 'renew':
        _showRenewalDialog(context);
        break;
      case 'terminate':
        _showTerminationDialog(context);
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
  }

  void _editLease(BuildContext context) {
    // Navigate to edit lease page
    Navigator.of(context).pushNamed('/edit-lease', arguments: lease);
  }

  void _showRenewalDialog(BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (context) => LeaseRenewalDialog(lease: lease),
    // );
  }

  void _showTerminationDialog(BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (context) => LeaseTerminationDialog(lease: lease),
    // );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Lease'),
            content: const Text(
              'Are you sure you want to delete this lease? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<LeaseBloc>().add(DeleteLeaseEvent(lease.id));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _downloadAttachment(String attachment) {
    // Implement file download logic
  }

  void _viewAttachment(String attachment) {
    // Implement file viewer logic
  }

  String _formatLeaseType(LeaseType type) {
    switch (type) {
      case LeaseType.residential:
        return 'Residential';
      case LeaseType.commercial:
        return 'Commercial';
      case LeaseType.shortTerm:
        return 'Short Term';
      case LeaseType.longTerm:
        return 'Long Term';
    }
  }

  String _formatRentFrequency(RentFrequency frequency) {
    switch (frequency) {
      case RentFrequency.monthly:
        return 'Monthly';
      case RentFrequency.quarterly:
        return 'Quarterly';
      case RentFrequency.biannual:
        return 'Bi-annual';
      case RentFrequency.annual:
        return 'Annual';
    }
  }
}
