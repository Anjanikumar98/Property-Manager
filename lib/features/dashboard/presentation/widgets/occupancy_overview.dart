// lib/features/dashboard/presentation/widgets/occupancy_overview.dart
import 'package:flutter/material.dart';

class OccupancyOverview extends StatelessWidget {
  final int totalProperties;
  final int activeLeases;
  final int vacantProperties;
  final double occupancyRate;

  const OccupancyOverview({
    Key? key,
    required this.totalProperties,
    required this.activeLeases,
    required this.vacantProperties,
    required this.occupancyRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Occupancy Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _OccupancyItem(
                  label: 'Occupied',
                  value: activeLeases,
                  color: Colors.green,
                ),
                _OccupancyItem(
                  label: 'Vacant',
                  value: vacantProperties,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _OccupancyBar(occupancyRate: occupancyRate),
          ],
        ),
      ),
    );
  }
}

class _OccupancyItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _OccupancyItem({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}

class _OccupancyBar extends StatelessWidget {
  final double occupancyRate;

  const _OccupancyBar({Key? key, required this.occupancyRate})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Occupancy Rate: ${occupancyRate.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: occupancyRate / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
