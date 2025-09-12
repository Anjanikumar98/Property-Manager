// lib/features/payments/presentation/widgets/payment_status_indicator.dart
import 'package:flutter/material.dart';
import '../../domain/entities/payment.dart';

class PaymentStatusIndicator extends StatelessWidget {
  final Payment payment;
  final bool showText;
  final double size;

  const PaymentStatusIndicator({
    Key? key,
    required this.payment,
    this.showText = true,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        border: Border.all(color: _getStatusColor()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          if (showText) ...[
            const SizedBox(width: 6),
            Text(
              payment.statusText,
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
