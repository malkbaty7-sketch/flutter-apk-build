import 'package:flutter/material.dart';
import 'package:katib/screens/home/home_screen.dart';

/// بطاقة الميزة
class FeatureCard extends StatelessWidget {
  final Feature feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: feature.color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // يمكن إضافة إجراء عند النقر
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  feature.icon,
                  size: 28,
                  color: feature.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                feature.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                feature.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
