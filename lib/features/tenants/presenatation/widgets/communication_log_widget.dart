// lib/features/tenants/presentation/widgets/communication_log_widget.dart
import 'package:flutter/material.dart';
import '../../domain/entities/tenant.dart';

class CommunicationLogWidget extends StatelessWidget {
  final List<CommunicationLog> communications;
  final VoidCallback? onAddCommunication;

  const CommunicationLogWidget({
    Key? key,
    required this.communications,
    this.onAddCommunication,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (communications.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: communications.length,
      itemBuilder: (context, index) {
        final communication = communications[index];
        return _buildCommunicationCard(context, communication);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.message_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No communications yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with your tenant',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          if (onAddCommunication != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddCommunication,
              icon: const Icon(Icons.add),
              label: const Text('Add Communication'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommunicationCard(
    BuildContext context,
    CommunicationLog communication,
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
                _buildTypeIcon(communication.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        communication.subject,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildMethodChip(communication.method),
                          const SizedBox(width: 8),
                          Text(
                            _formatDateTime(communication.communicatedAt),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildTypeChip(context, communication.type),
              ],
            ),
            if (communication.content != null) ...[
              const SizedBox(height: 12),
              Text(
                communication.content!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (communication.initiatedBy != null) ...[
              const SizedBox(height: 8),
              Text(
                'Initiated by: ${communication.initiatedBy}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(CommunicationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case CommunicationType.inquiry:
        icon = Icons.help_outline;
        color = Colors.blue;
        break;
      case CommunicationType.complaint:
        icon = Icons.report_problem_outlined;
        color = Colors.red;
        break;
      case CommunicationType.maintenance:
        icon = Icons.build_outlined;
        color = Colors.orange;
        break;
      case CommunicationType.payment:
        icon = Icons.payment_outlined;
        color = Colors.green;
        break;
      case CommunicationType.lease:
        icon = Icons.description_outlined;
        color = Colors.purple;
        break;
      case CommunicationType.emergency:
        icon = Icons.emergency_outlined;
        color = Colors.red[800]!;
        break;
      default:
        icon = Icons.message_outlined;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 24);
  }

  Widget _buildTypeChip(BuildContext context, CommunicationType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getTypeDisplayName(type),
        style: TextStyle(
          color: _getTypeColor(type),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMethodChip(CommunicationMethod method) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getMethodDisplayName(method),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _getTypeColor(CommunicationType type) {
    switch (type) {
      case CommunicationType.inquiry:
        return Colors.blue;
      case CommunicationType.complaint:
        return Colors.red;
      case CommunicationType.maintenance:
        return Colors.orange;
      case CommunicationType.payment:
        return Colors.green;
      case CommunicationType.lease:
        return Colors.purple;
      case CommunicationType.emergency:
        return Colors.red[800]!;
      default:
        return Colors.grey;
    }
  }

  String _getTypeDisplayName(CommunicationType type) {
    switch (type) {
      case CommunicationType.inquiry:
        return 'Inquiry';
      case CommunicationType.complaint:
        return 'Complaint';
      case CommunicationType.maintenance:
        return 'Maintenance';
      case CommunicationType.payment:
        return 'Payment';
      case CommunicationType.lease:
        return 'Lease';
      case CommunicationType.emergency:
        return 'Emergency';
      default:
        return 'General';
    }
  }

  String _getMethodDisplayName(CommunicationMethod method) {
    switch (method) {
      case CommunicationMethod.email:
        return 'Email';
      case CommunicationMethod.phone:
        return 'Phone';
      case CommunicationMethod.inPerson:
        return 'In Person';
      case CommunicationMethod.sms:
        return 'SMS';
      case CommunicationMethod.mail:
        return 'Mail';
      default:
        return 'Other';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// lib/features/tenants/presentation/widgets/payment_history_widget.dart
class PaymentHistoryWidget extends StatelessWidget {
  final List<PaymentHistory> payments;

  const PaymentHistoryWidget({Key? key, required this.payments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group payments by month/year for better organization
    final groupedPayments = _groupPaymentsByMonth(payments);

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedPayments.keys.length,
      itemBuilder: (context, index) {
        final monthYear = groupedPayments.keys.elementAt(index);
        final monthPayments = groupedPayments[monthYear]!;

        return _buildMonthSection(context, monthYear, monthPayments);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No payment history',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Payment records will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(
    BuildContext context,
    String monthYear,
    List<PaymentHistory> monthPayments,
  ) {
    final totalAmount = monthPayments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );

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
                Text(
                  monthYear,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...monthPayments.map(
            (payment) => _buildPaymentTile(context, payment),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context, PaymentHistory payment) {
    return ListTile(
      leading: _buildPaymentIcon(payment.type, payment.status),
      title: Text(
        '${_getPaymentTypeDisplayName(payment.type)}${payment.description != null ? ' - ${payment.description}' : ''}',
      ),
      subtitle: Text(
        '${_getMethodDisplayName(payment.method)} • ${_formatDate(payment.paidAt)}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${payment.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getAmountColor(payment.type),
            ),
          ),
          _buildStatusChip(payment.status),
        ],
      ),
    );
  }

  Widget _buildPaymentIcon(String type, PaymentStatus status) {
    IconData icon;
    Color color;

    switch (type) {
      case 'rent':
        icon = Icons.home;
        break;
      case 'deposit':
        icon = Icons.security;
        break;
      case 'fee':
        icon = Icons.receipt;
        break;
      case 'refund':
        icon = Icons.keyboard_return;
        break;
      default:
        icon = Icons.payment;
    }

    switch (status) {
      case PaymentStatus.completed:
        color = Colors.green;
        break;
      case PaymentStatus.pending:
        color = Colors.orange;
        break;
      case PaymentStatus.failed:
        color = Colors.red;
        break;
      case PaymentStatus.refunded:
        color = Colors.blue;
        break;
      case PaymentStatus.disputed:
        color = Colors.purple;
        break;
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.overdue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partiallyPaid:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusChip(PaymentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getStatusDisplayName(status),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Map<String, List<PaymentHistory>> _groupPaymentsByMonth(
    List<PaymentHistory> payments,
  ) {
    final Map<String, List<PaymentHistory>> grouped = {};

    for (final payment in payments) {
      final monthYear =
          '${_getMonthName(payment.paidAt.month)} ${payment.paidAt.year}';
      grouped.putIfAbsent(monthYear, () => []).add(payment);
    }

    return grouped;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Color _getAmountColor(String type) {
    switch (type) {
      case 'refund':
        return Colors.blue;
      default:
        return Colors.green[700]!;
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.blue;
      case PaymentStatus.disputed:
        return Colors.purple;
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.overdue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partiallyPaid:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getPaymentTypeDisplayName(String type) {
    switch (type) {
      case 'rent':
        return 'Rent Payment';
      case 'deposit':
        return 'Security Deposit';
      case 'fee':
        return 'Fee';
      case 'refund':
        return 'Refund';
      default:
        return 'Payment';
    }
  }

  String _getMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      default:
        return 'Other';
    }
  }

  String _getStatusDisplayName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.disputed:
        return 'Disputed';
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.overdue:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.cancelled:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partiallyPaid:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
