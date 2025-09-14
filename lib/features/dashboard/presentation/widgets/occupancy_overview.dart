import 'package:flutter/material.dart';
import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';

class OccupancyOverview extends StatefulWidget {
  final OccupancyData occupancyData;

  const OccupancyOverview({super.key, required this.occupancyData});

  @override
  State<OccupancyOverview> createState() => _OccupancyOverviewState();
}

class _OccupancyOverviewState extends State<OccupancyOverview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
          _buildOccupancyCircle(),
          const SizedBox(height: 24),
          _buildStatusBreakdown(),
          const SizedBox(height: 16),
          _buildPropertyBreakdown(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pie_chart,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Occupancy Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Current unit status',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancyCircle() {
    final occupancyRate = widget.occupancyData.occupancyRate;

    return Center(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: (occupancyRate / 100) * _animation.value,
                    strokeWidth: 12,
                    backgroundColor: Theme.of(
                      context,
                    ).dividerColor.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getOccupancyColor(occupancyRate),
                    ),
                  ),
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final animatedRate = occupancyRate * _animation.value;
                    return Text(
                      '${animatedRate.toStringAsFixed(1)}%',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getOccupancyColor(occupancyRate),
                      ),
                    );
                  },
                ),
                Text(
                  'Occupied',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBreakdown() {
    final data = widget.occupancyData;

    return Column(
      children: [
        _buildStatusBar(
          'Occupied',
          data.occupiedUnits,
          data.totalUnits,
          Colors.green,
          Icons.check_circle,
        ),
        const SizedBox(height: 12),
        _buildStatusBar(
          'Vacant',
          data.vacantUnits,
          data.totalUnits,
          Colors.orange,
          Icons.home_outlined,
        ),
        const SizedBox(height: 12),
        _buildStatusBar(
          'Maintenance',
          data.maintenanceUnits,
          data.totalUnits,
          Colors.red,
          Icons.build,
        ),
      ],
    );
  }

  Widget _buildStatusBar(
    String label,
    int count,
    int total,
    Color color,
    IconData icon,
  ) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$count units (${percentage.toStringAsFixed(1)}%)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: (percentage / 100) * _animation.value,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyBreakdown() {
    if (widget.occupancyData.propertyBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Breakdown',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...widget.occupancyData.propertyBreakdown
            .take(5) // Show top 5 properties
            .map((property) => _buildPropertyItem(property)),
        if (widget.occupancyData.propertyBreakdown.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                _showAllPropertiesDialog();
              },
              child: Text(
                'View ${widget.occupancyData.propertyBreakdown.length - 5} more properties',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPropertyItem(PropertyOccupancy property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: _getOccupancyColor(property.occupancyRate),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.propertyName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${property.occupiedUnits}/${property.totalUnits} units',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      CurrencyFormatter.format(property.revenue),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${property.occupancyRate.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getOccupancyColor(property.occupancyRate),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor:
                          (property.occupancyRate / 100) * _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getOccupancyColor(property.occupancyRate),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllPropertiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Properties'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.occupancyData.propertyBreakdown.length,
              itemBuilder: (context, index) {
                return _buildPropertyItem(
                  widget.occupancyData.propertyBreakdown[index],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Color _getOccupancyColor(double occupancyRate) {
    if (occupancyRate >= 90) {
      return Colors.green;
    } else if (occupancyRate >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

// Data model classes
class OccupancyData {
  final int occupiedUnits;
  final int vacantUnits;
  final int maintenanceUnits;
  final List<PropertyOccupancy> propertyBreakdown;

  OccupancyData({
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.maintenanceUnits,
    required this.propertyBreakdown,
  });

  factory OccupancyData.empty() => OccupancyData(
    occupiedUnits: 0,
    vacantUnits: 0,
    maintenanceUnits: 0,
    propertyBreakdown: [],
  );

  int get totalUnits => occupiedUnits + vacantUnits + maintenanceUnits;

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0.0;
}

class PropertyOccupancy {
  final String propertyId;
  final String propertyName;
  final int totalUnits;
  final int occupiedUnits;
  final double revenue;

  PropertyOccupancy({
    required this.propertyId,
    required this.propertyName,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.revenue,
  });

  double get occupancyRate =>
      totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0.0;
}
