// lib/features/payments/presentation/widgets/payment_status_indicator.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/payments/domain/entities/payment.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
import '../../data/models/payment_model.dart';

class PaymentStatusIndicator extends StatelessWidget {
  final Payment? payment;
  final PaymentStatus? status;
  final int? daysOverdue;
  final bool showText;
  final double size;

  const PaymentStatusIndicator({
    Key? key,
    this.payment,
    this.status,
    this.daysOverdue,
    this.showText = true,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = status ?? payment?.status ?? PaymentStatus.pending;
    final effectiveDaysOverdue = daysOverdue ?? payment?.daysOverdue;

    final statusInfo = _getStatusInfo(effectiveStatus, effectiveDaysOverdue);

    if (showText) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusInfo.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusInfo.icon, size: size, color: statusInfo.textColor),
            const SizedBox(width: 4),
            Text(
              statusInfo.text,
              style: TextStyle(
                color: statusInfo.textColor,
                fontSize: size,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Icon(statusInfo.icon, size: size, color: statusInfo.iconColor);
  }

  PaymentStatusInfo _getStatusInfo(PaymentStatus status, int? daysOverdue) {
    switch (status) {
      case PaymentStatus.paid:
      case PaymentStatus.completed:
        return PaymentStatusInfo(
          text: 'Paid',
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade100,
          textColor: Colors.green.shade800,
          iconColor: Colors.green,
        );

      case PaymentStatus.pending:
        return PaymentStatusInfo(
          text: 'Pending',
          icon: Icons.schedule,
          backgroundColor: Colors.orange.shade100,
          textColor: Colors.orange.shade800,
          iconColor: Colors.orange,
        );

      case PaymentStatus.overdue:
        final text =
            daysOverdue != null && daysOverdue! > 0
                ? 'Overdue ($daysOverdue days)'
                : 'Overdue';
        return PaymentStatusInfo(
          text: text,
          icon: Icons.warning,
          backgroundColor: Colors.red.shade100,
          textColor: Colors.red.shade800,
          iconColor: Colors.red,
        );

      case PaymentStatus.partial:
      case PaymentStatus.partiallyPaid:
        return PaymentStatusInfo(
          text: 'Partial',
          icon: Icons.pie_chart,
          backgroundColor: Colors.blue.shade100,
          textColor: Colors.blue.shade800,
          iconColor: Colors.blue,
        );

      case PaymentStatus.cancelled:
        return PaymentStatusInfo(
          text: 'Cancelled',
          icon: Icons.cancel,
          backgroundColor: Colors.grey.shade100,
          textColor: Colors.grey.shade800,
          iconColor: Colors.grey,
        );
    }
  }
}

class PaymentStatusInfo {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const PaymentStatusInfo({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });
}

// lib/features/payments/presentation/widgets/payment_history_card.dart
class PaymentHistoryCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback? onTap;
  final VoidCallback? onReceiptTap;

  const PaymentHistoryCard({
    Key? key,
    required this.payment,
    this.onTap,
    this.onReceiptTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPaymentTypeDisplay(payment.type),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Due: ${_formatDate(payment.dueDate)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PaymentStatusIndicator(
                    status: payment.status,
                    daysOverdue: payment.daysOverdue,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Amount and payment info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${payment.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getAmountColor(context, payment.status),
                          ),
                        ),
                        if (payment.lateFee > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Includes \$${payment.lateFee.toStringAsFixed(2)} late fee',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (payment.paidDate != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Paid: ${_formatDate(payment.paidDate!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (payment.paymentMethod != null)
                          Text(
                            _getPaymentMethodDisplay(payment.paymentMethod!),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              if (payment.description != null &&
                  payment.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  payment.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Action buttons
              if (payment.status == PaymentStatus.paid ||
                  payment.status == PaymentStatus.completed) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (onReceiptTap != null)
                      TextButton.icon(
                        onPressed: onReceiptTap,
                        icon: const Icon(Icons.receipt, size: 16),
                        label: const Text('Receipt'),
                      ),
                    const Spacer(),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAmountColor(BuildContext context, PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.overdue:
        return Colors.red;
      case PaymentStatus.pending:
        return Theme.of(context).colorScheme.primary;
      case PaymentStatus.partial:
      case PaymentStatus.partiallyPaid:
        return Colors.orange;
      case PaymentStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getPaymentTypeDisplay(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return 'Rent Payment';
      case PaymentType.deposit:
        return 'Security Deposit';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.maintenance:
        return 'Maintenance Fee';
      case PaymentType.utility:
      case PaymentType.utilities:
        return 'Utility Payment';
      case PaymentType.other:
        return 'Other Payment';
    }
  }

  String _getPaymentMethodDisplay(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'check':
        return 'Check';
      case 'bank_transfer':
      case 'banktransfer':
        return 'Bank Transfer';
      case 'online_payment':
      case 'onlinepayment':
        return 'Online Payment';
      case 'credit_card':
      case 'creditcard':
        return 'Credit Card';
      case 'debit_card':
      case 'debitcard':
        return 'Debit Card';
      case 'other':
        return 'Other';
      default:
        return method;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// lib/features/payments/presentation/widgets/payment_summary_widget.dart
class PaymentSummaryWidget extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;
  final double overdueAmount;
  final double pendingAmount;

  const PaymentSummaryWidget({
    Key? key,
    required this.totalAmount,
    required this.paidAmount,
    required this.overdueAmount,
    required this.pendingAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Total',
                  amount: totalAmount,
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Paid',
                  amount: paidAmount,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Overdue',
                  amount: overdueAmount,
                  color: Colors.red,
                  icon: Icons.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context: context,
                  title: 'Pending',
                  amount: pendingAmount,
                  color: Colors.orange,
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// lib/features/payments/presentation/widgets/overdue_payments_widget.dart
class OverduePaymentsWidget extends StatelessWidget {
  final List<PaymentModel> overduePayments;
  final VoidCallback? onViewAll;
  final Function(PaymentModel)? onPaymentTap;

  const OverduePaymentsWidget({
    Key? key,
    required this.overduePayments,
    this.onViewAll,
    this.onPaymentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (overduePayments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Overdue Payments (${overduePayments.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: overduePayments.take(3).length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final payment = overduePayments[index];
              return _buildOverdueItem(context, payment);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueItem(BuildContext context, PaymentModel payment) {
    return InkWell(
      onTap: () => onPaymentTap?.call(payment),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getPaymentTypeDisplay(payment.type),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${_formatDate(payment.dueDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${payment.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  '${payment.daysOverdue} days overdue',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentTypeDisplay(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return 'Rent Payment';
      case PaymentType.deposit:
        return 'Security Deposit';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.maintenance:
        return 'Maintenance Fee';
      case PaymentType.utility:
      case PaymentType.utilities:
        return 'Utility Payment';
      case PaymentType.other:
        return 'Other Payment';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
