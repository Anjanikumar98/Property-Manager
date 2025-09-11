// lib/features/payments/presentation/widgets/payment_summary_card.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double totalDue;
  final double totalPaid;
  final double totalOverdue;
  final int overdueCount;
  final int totalPayments;

  const PaymentSummaryCard({
    Key? key,
    required this.totalDue,
    required this.totalPaid,
    required this.totalOverdue,
    required this.overdueCount,
    required this.totalPayments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collectionRate = totalDue > 0 ? (totalPaid / totalDue) * 100 : 100.0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Due',
                    CurrencyFormatter.format(totalDue),
                    Colors.blue,
                    Icons.account_balance_wallet,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Collected',
                    CurrencyFormatter.format(totalPaid),
                    Colors.green,
                    Icons.payments,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Overdue',
                    CurrencyFormatter.format(totalOverdue),
                    Colors.red,
                    Icons.warning,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Collection Rate',
                    '${collectionRate.toStringAsFixed(1)}%',
                    collectionRate >= 90 ? Colors.green : Colors.orange,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountItem('Total Payments', totalPayments, Colors.blue),
                _buildCountItem('Overdue', overdueCount, Colors.red),
                _buildCountItem(
                  'On Time',
                  totalPayments - overdueCount,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCountItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
