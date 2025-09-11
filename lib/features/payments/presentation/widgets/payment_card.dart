// lib/features/payments/presentation/widgets/payment_card.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';
import '../../domain/entities/payment.dart';
import 'payment_status_indicator.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRecordPartialPayment;

  const PaymentCard({
    Key? key,
    required this.payment,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onRecordPartialPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
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
                          payment.typeText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (payment.description != null)
                          Text(
                            payment.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  PaymentStatusIndicator(payment: payment),
                ],
              ),
              const SizedBox(height: 12),

              _buildAmountInfo(),
              const SizedBox(height: 12),

              _buildDateInfo(),
              const SizedBox(height: 12),

              if (payment.isOverdue && !payment.isFullyPaid)
                _buildOverdueAlert(),

              if (!payment.isFullyPaid &&
                  (onEdit != null || onRecordPartialPayment != null))
                _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Amount Due:'),
            Text(
              CurrencyFormatter.format(payment.amount),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        if (payment.lateFee > 0) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Late Fee:', style: TextStyle(color: Colors.orange)),
              Text(
                CurrencyFormatter.format(payment.lateFee),
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Paid:'),
            Text(
              CurrencyFormatter.format(payment.paidAmount),
              style: TextStyle(
                color: payment.paidAmount > 0 ? Colors.green : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (!payment.isFullyPaid) ...[
          const SizedBox(height: 4),
          const Divider(),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Remaining:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                CurrencyFormatter.format(payment.totalRemainingAmount),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDateInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Due Date',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '${payment.dueDate.day}/${payment.dueDate.month}/${payment.dueDate.year}',
              style: TextStyle(
                color: payment.isOverdue ? Colors.red : null,
                fontWeight: payment.isOverdue ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        if (payment.paidDate != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Paid Date',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '${payment.paidDate!.day}/${payment.paidDate!.month}/${payment.paidDate!.year}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildOverdueAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Overdue by ${payment.daysOverdue} days',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          if (onRecordPartialPayment != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRecordPartialPayment,
                icon: const Icon(Icons.payment, size: 16),
                label: const Text('Pay Partial'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          if (onRecordPartialPayment != null && onEdit != null)
            const SizedBox(width: 8),
          if (onEdit != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (payment.status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.overdue:
        return Colors.red;
      case PaymentStatus.partiallyPaid:
        return Colors.blue;
      case PaymentStatus.cancelled:
        return Colors.grey;
    }
  }
}
