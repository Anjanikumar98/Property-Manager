// lib/features/leases/presentation/widgets/lease_history_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaseHistoryWidget extends StatelessWidget {
  final String leaseId;

  const LeaseHistoryWidget({Key? key, required this.leaseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lease History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHistoryTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTimeline() {
    // Mock data - in real app, this would come from a repository
    final historyItems = _getMockHistoryItems();

    return Column(
      children: historyItems.map((item) => _buildHistoryItem(item)).toList(),
    );
  }

  Widget _buildHistoryItem(LeaseHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getActionColor(item.action),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActionIcon(item.action),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.description!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat(
                        'MMM dd, yyyy • hh:mm a',
                      ).format(item.timestamp),
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                    ),
                    if (item.user != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.person, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        item.user!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ],
                ),
                if (item.oldValue != null || item.newValue != null)
                  _buildChangeDetails(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeDetails(LeaseHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.oldValue != null)
            Row(
              children: [
                const Icon(Icons.remove, size: 12, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  'Previous: ${item.oldValue}',
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ],
            ),
          if (item.newValue != null)
            Row(
              children: [
                const Icon(Icons.add, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Updated: ${item.newValue}',
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getActionColor(LeaseHistoryAction action) {
    switch (action) {
      case LeaseHistoryAction.created:
        return Colors.blue;
      case LeaseHistoryAction.updated:
        return Colors.orange;
      case LeaseHistoryAction.renewed:
        return Colors.green;
      case LeaseHistoryAction.terminated:
        return Colors.red;
      case LeaseHistoryAction.statusChanged:
        return Colors.purple;
      case LeaseHistoryAction.paymentReceived:
        return Colors.teal;
      case LeaseHistoryAction.documentAdded:
        return Colors.indigo;
      case LeaseHistoryAction.noteAdded:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(LeaseHistoryAction action) {
    switch (action) {
      case LeaseHistoryAction.created:
        return Icons.add_circle;
      case LeaseHistoryAction.updated:
        return Icons.edit;
      case LeaseHistoryAction.renewed:
        return Icons.refresh;
      case LeaseHistoryAction.terminated:
        return Icons.stop_circle;
      case LeaseHistoryAction.statusChanged:
        return Icons.swap_horiz;
      case LeaseHistoryAction.paymentReceived:
        return Icons.payment;
      case LeaseHistoryAction.documentAdded:
        return Icons.attach_file;
      case LeaseHistoryAction.noteAdded:
        return Icons.note_add;
    }
  }

  List<LeaseHistoryItem> _getMockHistoryItems() {
    final now = DateTime.now();

    return [
      LeaseHistoryItem(
        id: '1',
        action: LeaseHistoryAction.paymentReceived,
        title: 'Rent Payment Received',
        description: 'Monthly rent payment for December 2024',
        timestamp: now.subtract(const Duration(days: 2)),
        user: 'System',
        newValue: '\$1,200.00',
      ),
      LeaseHistoryItem(
        id: '2',
        action: LeaseHistoryAction.noteAdded,
        title: 'Note Added',
        description: 'Tenant reported issue with kitchen faucet',
        timestamp: now.subtract(const Duration(days: 5)),
        user: 'Property Manager',
      ),
      LeaseHistoryItem(
        id: '3',
        action: LeaseHistoryAction.updated,
        title: 'Lease Updated',
        description: 'Monthly rent amount updated',
        timestamp: now.subtract(const Duration(days: 15)),
        user: 'Admin',
        oldValue: '\$1,150.00',
        newValue: '\$1,200.00',
      ),
      LeaseHistoryItem(
        id: '4',
        action: LeaseHistoryAction.documentAdded,
        title: 'Document Added',
        description: 'Insurance certificate uploaded',
        timestamp: now.subtract(const Duration(days: 30)),
        user: 'Tenant',
      ),
      LeaseHistoryItem(
        id: '5',
        action: LeaseHistoryAction.statusChanged,
        title: 'Status Changed',
        description: 'Lease status updated from Draft to Active',
        timestamp: now.subtract(const Duration(days: 60)),
        user: 'Property Manager',
        oldValue: 'Draft',
        newValue: 'Active',
      ),
      LeaseHistoryItem(
        id: '6',
        action: LeaseHistoryAction.created,
        title: 'Lease Created',
        description: 'New lease agreement created',
        timestamp: now.subtract(const Duration(days: 62)),
        user: 'Property Manager',
      ),
    ];
  }
}

class LeaseHistoryItem {
  final String id;
  final LeaseHistoryAction action;
  final String title;
  final String? description;
  final DateTime timestamp;
  final String? user;
  final String? oldValue;
  final String? newValue;

  LeaseHistoryItem({
    required this.id,
    required this.action,
    required this.title,
    this.description,
    required this.timestamp,
    this.user,
    this.oldValue,
    this.newValue,
  });
}

enum LeaseHistoryAction {
  created,
  updated,
  renewed,
  terminated,
  statusChanged,
  paymentReceived,
  documentAdded,
  noteAdded,
}
