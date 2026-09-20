import 'package:flutter/material.dart';
import 'package:katib/screens/projects/projects_screen.dart';

/// بطاقة المشروع
class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // أيقونة نوع المشروع
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: project.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      project.icon,
                      size: 24,
                      color: project.color,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // معلومات المشروع
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        Text(
                          project.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // النوع والحالة
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                project.type,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStatusColor(context, project.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                project.status,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: _getStatusTextColor(context, project.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // زر المفضل
                  IconButton(
                    icon: Icon(
                      project.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: project.isFavorite 
                          ? Theme.of(context).colorScheme.error 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: (e) {
                      e.stopPropagation();
                      onFavoriteTap();
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // شريط التقدم
              LinearProgressIndicator(
                value: project.progress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.color,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // الإحصائيات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${project.pages} صفحات',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${project.words} كلمة',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    project.lastModified,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// الحصول على لون الحالة
  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green.withOpacity(0.2);
      case 'قيد المراجعة':
        return Colors.orange.withOpacity(0.2);
      case 'قيد العمل':
        return Colors.blue.withOpacity(0.2);
      case 'مسودة':
        return Colors.grey.withOpacity(0.2);
      default:
        return Theme.of(context).colorScheme.surfaceVariant;
    }
  }

  /// الحصول على لون نص الحالة
  Color _getStatusTextColor(BuildContext context, String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'قيد المراجعة':
        return Colors.orange;
      case 'قيد العمل':
        return Colors.blue;
      case 'مسودة':
        return Colors.grey;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }
}
