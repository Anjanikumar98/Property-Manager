// lib/features/tenants/presentation/pages/tenant_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/entities/tenant.dart';
import 'add_tenant_page.dart';

class TenantDetailPage extends StatefulWidget {
  final Tenant tenant;

  const TenantDetailPage({Key? key, required this.tenant}) : super(key: key);

  @override
  State<TenantDetailPage> createState() => _TenantDetailPageState();
}

class _TenantDetailPageState extends State<TenantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.tenant.fullName,
        showBackButton: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Tenant'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'change_status',
                    child: ListTile(
                      leading: Icon(Icons.swap_horiz),
                      title: Text('Change Status'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'add_communication',
                    child: ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Add Communication'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'archive',
                    child: ListTile(
                      leading: Icon(Icons.archive, color: Colors.orange),
                      title: Text(
                        'Archive Tenant',
                        style: TextStyle(color: Colors.orange),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderCard(context),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                // _buildCommunicationTab(),
                // _buildPaymentHistoryTab(),
                // _buildAddressHistoryTab(),
                // _buildContactHistoryTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tenant.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(),
                  if (widget.tenant.occupation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.tenant.occupation!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildQuickStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: _getStatusColor().withOpacity(0.1),
      child: Text(
        widget.tenant.firstName.isNotEmpty && widget.tenant.lastName.isNotEmpty
            ? '${widget.tenant.firstName[0]}${widget.tenant.lastName[0]}'
                .toUpperCase()
            : 'T',
        style: TextStyle(
          color: _getStatusColor(),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          color: _getStatusColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        if (widget.tenant.propertyIds.isNotEmpty) ...[
          Icon(Icons.home, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '${widget.tenant.propertyIds.length} Properties',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
        ],
        Icon(Icons.message, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '${widget.tenant.communicationHistory.length} Messages',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Communications'),
          Tab(text: 'Payments'),
          Tab(text: 'Addresses'),
          Tab(text: 'Contacts'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildPersonalInfoCard(context),
          const SizedBox(height: 16),
          _buildContactInfoCard(context),
          if (widget.tenant.emergencyContactName != null ||
              widget.tenant.emergencyContactPhone != null) ...[
            const SizedBox(height: 16),
            _buildEmergencyContactCard(context),
          ],
          const SizedBox(height: 16),
          _buildLeaseInfoCard(context),
          const SizedBox(height: 16),
          _buildAdditionalInfoCard(context),
          if (widget.tenant.propertyIds.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPropertiesCard(context),
          ],
        ],
      ),
    );
  }

  // Widget _buildCommunicationTab() {
  //   return CommunicationLogWidget(
  //     communications: widget.tenant.communicationHistory,
  //     onAddCommunication: _showAddCommunicationDialog,
  //   );
  // }
  //
  // Widget _buildPaymentHistoryTab() {
  //   return PaymentHistoryWidget(payments: widget.tenant.paymentHistory);
  // }
  //
  // Widget _buildAddressHistoryTab() {
  //   return AddressHistoryWidget(addresses: widget.tenant.addressHistory);
  // }
  //
  // Widget _buildContactHistoryTab() {
  //   return ContactHistoryWidget(contacts: widget.tenant.contactHistory);
  // }

  Widget _buildLeaseInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lease Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.tenant.leaseStartDate != null)
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Lease Start',
                _formatDate(widget.tenant.leaseStartDate!),
              ),
            if (widget.tenant.leaseEndDate != null)
              _buildInfoRow(
                context,
                Icons.event,
                'Lease End',
                _formatDate(widget.tenant.leaseEndDate!),
              ),
            if (widget.tenant.monthlyIncome != null)
              _buildInfoRow(
                context,
                Icons.attach_money,
                'Monthly Income',
                '\$${widget.tenant.monthlyIncome!.toStringAsFixed(2)}',
                valueColor: Colors.green[600],
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
            if (widget.tenant.dateOfBirth != null)
              _buildInfoRow(
                context,
                Icons.cake,
                'Date of Birth',
                _formatDate(widget.tenant.dateOfBirth!),
              ),
            if (widget.tenant.idNumber != null)
              _buildInfoRow(
                context,
                Icons.badge,
                'ID Number',
                widget.tenant.idNumber!,
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
              widget.tenant.email,
              onTap:
                  () => _copyToClipboard(context, widget.tenant.email, 'Email'),
            ),
            _buildClickableInfoRow(
              context,
              Icons.phone,
              'Phone',
              widget.tenant.phone,
              onTap:
                  () => _copyToClipboard(context, widget.tenant.phone, 'Phone'),
            ),
            if (widget.tenant.address != null)
              _buildInfoRow(
                context,
                Icons.location_on,
                'Address',
                widget.tenant.address!,
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
            if (widget.tenant.emergencyContactName != null)
              _buildInfoRow(
                context,
                Icons.contact_emergency,
                'Name',
                widget.tenant.emergencyContactName!,
              ),
            if (widget.tenant.emergencyContactPhone != null)
              _buildClickableInfoRow(
                context,
                Icons.phone_in_talk,
                'Phone',
                widget.tenant.emergencyContactPhone!,
                onTap:
                    () => _copyToClipboard(
                      context,
                      widget.tenant.emergencyContactPhone!,
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
            if (widget.tenant.notes != null)
              _buildInfoRow(context, Icons.note, 'Notes', widget.tenant.notes!),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Added',
              _formatDate(widget.tenant.createdAt),
            ),
            if (widget.tenant.updatedAt != widget.tenant.createdAt)
              _buildInfoRow(
                context,
                Icons.update,
                'Last Updated',
                _formatDate(widget.tenant.updatedAt),
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
              '${widget.tenant.propertyIds.length} ${widget.tenant.propertyIds.length == 1 ? 'Property' : 'Properties'} assigned',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.tenant.propertyIds.map(
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

  Widget? _buildFloatingActionButton() {
    switch (_tabController.index) {
      case 1: // Communication tab
        return FloatingActionButton(
          onPressed: _showAddCommunicationDialog,
          child: const Icon(Icons.add),
          tooltip: 'Add Communication',
        );
      default:
        return null;
    }
  }

  Color _getStatusColor() {
    switch (widget.tenant.status) {
      case TenantStatus.active:
        return Colors.green[700]!;
      case TenantStatus.inactive:
        return Colors.grey[600]!;
      case TenantStatus.former:
        return Colors.orange[700]!;
      case TenantStatus.pending:
        return Colors.blue[700]!;
      case TenantStatus.suspended:
        return Colors.red[700]!;
    }
  }

  String _getStatusText() {
    switch (widget.tenant.status) {
      case TenantStatus.active:
        return 'Active Tenant';
      case TenantStatus.inactive:
        return 'Inactive';
      case TenantStatus.former:
        return 'Former Tenant';
      case TenantStatus.pending:
        return 'Pending';
      case TenantStatus.suspended:
        return 'Suspended';
    }
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        _navigateToEdit();
        break;
      case 'change_status':
        _showChangeStatusDialog();
        break;
      case 'add_communication':
        _showAddCommunicationDialog();
        break;
      case 'archive':
        _showArchiveDialog();
        break;
    }
  }

  void _navigateToEdit() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AddTenantPage(tenant: widget.tenant),
          ),
        )
        .then((result) {
          if (result == true) {
            Navigator.of(context).pop(true);
          }
        });
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  TenantStatus.values.map((status) {
                    return RadioListTile<TenantStatus>(
                      title: Text(_getStatusDisplayName(status)),
                      value: status,
                      groupValue: widget.tenant.status,
                      onChanged: (TenantStatus? value) {
                        if (value != null) {
                          Navigator.pop(context);
                          _updateTenantStatus(value);
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

  void _showAddCommunicationDialog() {
    // showDialog(
    //   context: context,
    //   builder:
    //       (context) => AddCommunicationDialog(
    //         tenantId: widget.tenant.id!,
    //         onCommunicationAdded: (communication) {
    //           // Handle adding communication
    //           // You would typically call a bloc method here
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(
    //               content: Text('Communication added successfully'),
    //             ),
    //           );
    //         },
    //       ),
    // );
  }

  void _showArchiveDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Archive Tenant'),
            content: Text(
              'Are you sure you want to archive ${widget.tenant.fullName}? This will change their status to Former and they will no longer appear in active tenant lists.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateTenantStatus(TenantStatus.former);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
                child: const Text('Archive'),
              ),
            ],
          ),
    );
  }

  void _updateTenantStatus(TenantStatus newStatus) {
    // This would typically update via bloc
    // context.read<TenantBloc>().add(UpdateTenantStatusEvent(widget.tenant.id!, newStatus));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to ${_getStatusDisplayName(newStatus)}'),
      ),
    );
  }

  String _getStatusDisplayName(TenantStatus status) {
    switch (status) {
      case TenantStatus.active:
        return 'Active';
      case TenantStatus.inactive:
        return 'Inactive';
      case TenantStatus.former:
        return 'Former Tenant';
      case TenantStatus.pending:
        return 'Pending';
      case TenantStatus.suspended:
        return 'Suspended';
    }
  }
}
