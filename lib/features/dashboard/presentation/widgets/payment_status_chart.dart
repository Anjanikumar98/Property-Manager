import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentStatusChart extends StatefulWidget {
  final PaymentStatusData paymentData;

  const PaymentStatusChart({super.key, required this.paymentData});

  @override
  State<PaymentStatusChart> createState() => _PaymentStatusChartState();
}

class _PaymentStatusChartState extends State<PaymentStatusChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildChart(),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Status',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Current month overview',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        _buildSummaryStats(),
      ],
    );
  }

  Widget _buildSummaryStats() {
    final total = widget.paymentData.totalPayments;
    final onTimeRate =
        total > 0
            ? (widget.paymentData.onTimePayments / total * 100).toStringAsFixed(
              1,
            )
            : '0.0';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatColumn(
              'Total Payments',
              total.toString(),
              Icons.payments,
              Theme.of(context).primaryColor,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: _buildStatColumn(
              'On-Time Rate',
              '$onTimeRate%',
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (widget.paymentData.totalPayments == 0) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: _buildPieChartSections(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 48,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            Text(
              'No payment data',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final data = widget.paymentData;
    final total = data.totalPayments.toDouble();

    if (total == 0) return [];

    final sections = <PieChartSectionData>[];

    if (data.onTimePayments > 0) {
      sections.add(
        _buildSection(
          0,
          data.onTimePayments / total * 100,
          Colors.green,
          'On Time',
          data.onTimePayments,
        ),
      );
    }

    if (data.latePayments > 0) {
      sections.add(
        _buildSection(
          1,
          data.latePayments / total * 100,
          Colors.orange,
          'Late',
          data.latePayments,
        ),
      );
    }

    if (data.pendingPayments > 0) {
      sections.add(
        _buildSection(
          2,
          data.pendingPayments / total * 100,
          Colors.blue,
          'Pending',
          data.pendingPayments,
        ),
      );
    }

    if (data.overduePayments > 0) {
      sections.add(
        _buildSection(
          3,
          data.overduePayments / total * 100,
          Colors.red,
          'Overdue',
          data.overduePayments,
        ),
      );
    }

    return sections;
  }

  PieChartSectionData _buildSection(
    int index,
    double percentage,
    Color color,
    String title,
    int count,
  ) {
    final isTouched = touchedIndex == index;
    final radius = isTouched ? 110.0 : 100.0;
    final fontSize = isTouched ? 16.0 : 14.0;
    final animatedPercentage = percentage * _animation.value;

    return PieChartSectionData(
      color: color,
      value: animatedPercentage,
      title:
          isTouched
              ? '$count\n${percentage.toStringAsFixed(1)}%'
              : '${percentage.toStringAsFixed(0)}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: isTouched ? _buildBadge(title, count, color) : null,
      badgePositionPercentageOffset: 1.3,
    );
  }

  Widget _buildBadge(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$title ($count)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        if (widget.paymentData.onTimePayments > 0)
          _buildLegendItem(
            'On Time',
            Colors.green,
            widget.paymentData.onTimePayments,
          ),
        if (widget.paymentData.latePayments > 0)
          _buildLegendItem(
            'Late',
            Colors.orange,
            widget.paymentData.latePayments,
          ),
        if (widget.paymentData.pendingPayments > 0)
          _buildLegendItem(
            'Pending',
            Colors.blue,
            widget.paymentData.pendingPayments,
          ),
        if (widget.paymentData.overduePayments > 0)
          _buildLegendItem(
            'Overdue',
            Colors.red,
            widget.paymentData.overduePayments,
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// Data model class
class PaymentStatusData {
  final int onTimePayments;
  final int latePayments;
  final int pendingPayments;
  final int overduePayments;

  PaymentStatusData({
    required this.onTimePayments,
    required this.latePayments,
    required this.pendingPayments,
    required this.overduePayments,
  });

  int get totalPayments =>
      onTimePayments + latePayments + pendingPayments + overduePayments;

  factory PaymentStatusData.empty() => PaymentStatusData(
    onTimePayments: 0,
    latePayments: 0,
    pendingPayments: 0,
    overduePayments: 0,
  );
}
