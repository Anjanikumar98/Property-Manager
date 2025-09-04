// lib/features/tenants/presentation/widgets/contact_history_widget.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';

class ContactHistoryWidget extends StatelessWidget {
  final List<ContactInfo> contacts;

  const ContactHistoryWidget({Key? key, required this.contacts})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group contacts by type
    final groupedContacts = <String, List<ContactInfo>>{};
    for (final contact in contacts) {
      groupedContacts.putIfAbsent(contact.type, () => []).add(contact);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedContacts.keys.length,
      itemBuilder: (context, index) {
        final type = groupedContacts.keys.elementAt(index);
        final typeContacts = groupedContacts[type]!;

        return _buildContactTypeSection(context, type, typeContacts);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_phone_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No contact history',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact changes will be tracked here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTypeSection(
    BuildContext context,
    String type,
    List<ContactInfo> typeContacts,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildContactTypeIcon(type),
                const SizedBox(width: 8),
                Text(
                  _getContactTypeDisplayName(type),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...typeContacts.map((contact) => _buildContactTile(context, contact)),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, ContactInfo contact) {
    final isCurrent = contact.validTo == null;

    return ListTile(
      title: Text(contact.value),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (contact.description != null && contact.description!.isNotEmpty)
            Text(contact.description!),
          Text(
            _formatDateRange(contact.validFrom, contact.validTo),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      trailing:
          isCurrent
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              )
              : null,
    );
  }

  Widget _buildContactTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'email':
        icon = Icons.email_outlined;
        color = Colors.blue;
        break;
      case 'phone':
        icon = Icons.phone_outlined;
        color = Colors.green;
        break;
      case 'emergency_contact':
        icon = Icons.contact_emergency_outlined;
        color = Colors.red;
        break;
      default:
        icon = Icons.contact_phone_outlined;
        color = Colors.grey;
    }

    return Icon(icon, color: color);
  }

  String _getContactTypeDisplayName(String type) {
    switch (type) {
      case 'email':
        return 'Email Addresses';
      case 'phone':
        return 'Phone Numbers';
      case 'emergency_contact':
        return 'Emergency Contacts';
      default:
        return 'Other Contacts';
    }
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
