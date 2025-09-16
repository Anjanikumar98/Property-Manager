// lib/features/dashboard/presentation/widgets/summary_cards.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/dashboard/data/models/dashboard_data_model.dart';

class SummaryCards extends StatefulWidget {
  final DashboardData data;

  const SummaryCards({super.key, required this.data});

  @override
  State<SummaryCards> createState() => _SummaryCardsState();
}

class _SummaryCardsState extends State<SummaryCards>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      4,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      ),
    );

    _animations =
        _controllers
            .map(
              (controller) => CurvedAnimation(
                parent: controller,
                curve: Curves.easeOutBack,
              ),
            )
            .toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid layout based on screen width
        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        double childAspectRatio = constraints.maxWidth > 600 ? 1.2 : 1.5;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
          children: [
            AnimatedBuilder(
              animation: _animations[0],
              builder:
                  (context, child) => Transform.scale(
                    scale: _animations[0].value,
                    child: _SummaryCard(
                      title: 'Total Properties',
                      value: widget.data.summaryData.totalProperties.toString(),
                      icon: Icons.home_work,
                      color: Colors.blue,
                      trend: null, // Can add trend calculation later
                      onTap: () => _navigateToProperties(context),
                    ),
                  ),
            ),
            AnimatedBuilder(
              animation: _animations[1],
              builder:
                  (context, child) => Transform.scale(
                    scale: _animations[1].value,
                    child: _SummaryCard(
                      title: 'Active Leases',
                      value: widget.data.summaryData.activeLeases.toString(),
                      icon: Icons.assignment,
                      color: Colors.green,
                      trend: null,
                      onTap: () => _navigateToLeases(context),
                    ),
                  ),
            ),
            AnimatedBuilder(
              animation: _animations[2],
              builder:
                  (context, child) => Transform.scale(
                    scale: _animations[2].value,
                    child: _SummaryCard(
                      title: 'Monthly Revenue',
                      value:
                          '₹${_formatCurrency(widget.data.summaryData.monthlyRevenue)}',
                      icon: Icons.trending_up,
                      color: Colors.orange,
                      trend: TrendData(
                        isPositive: true,
                        percentage: 12.5, // Mock trend
                      ),
                      onTap: () => _navigateToPayments(context),
                    ),
                  ),
            ),
            AnimatedBuilder(
              animation: _animations[3],
              builder:
                  (context, child) => Transform.scale(
                    scale: _animations[3].value,
                    child: _SummaryCard(
                      title: 'Occupancy Rate',
                      value:
                          '${widget.data.summaryData.occupancyRate.toStringAsFixed(1)}%',
                      icon: Icons.pie_chart,
                      color: _getOccupancyColor(
                        widget.data.summaryData.occupancyRate,
                      ),
                      trend: null,
                      onTap: () => _navigateToReports(context),
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  Color _getOccupancyColor(double occupancyRate) {
    if (occupancyRate >= 90) return Colors.green;
    if (occupancyRate >= 70) return Colors.orange;
    return Colors.red;
  }

  void _navigateToProperties(BuildContext context) {
    Navigator.pushNamed(context, '/properties');
  }

  void _navigateToLeases(BuildContext context) {
    Navigator.pushNamed(context, '/leases');
  }

  void _navigateToPayments(BuildContext context) {
    Navigator.pushNamed(context, '/payments');
  }

  void _navigateToReports(BuildContext context) {
    Navigator.pushNamed(context, '/reports');
  }
}

class TrendData {
  final bool isPositive;
  final double percentage;

  TrendData({required this.isPositive, required this.percentage});
}

class _SummaryCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final TrendData? trend;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.onTap,
  });

  @override
  State<_SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<_SummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value * 2,
                    offset: Offset(0, _elevationAnimation.value),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const Spacer(),
                        _buildValueSection(),
                        if (widget.trend != null) ...[
                          const SizedBox(height: 8),
                          _buildTrend(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_isHovered ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(widget.icon, color: widget.color, size: 20),
        ),
        if (widget.onTap != null)
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildValueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: _isHovered ? 26 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          child: Text(widget.value),
        ),
        const SizedBox(height: 4),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrend() {
    if (widget.trend == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            widget.trend!.isPositive
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.trend!.isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: widget.trend!.isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            '${widget.trend!.percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: widget.trend!.isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
