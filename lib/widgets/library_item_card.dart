import 'package:flutter/material.dart';
import 'package:katib/screens/library/library_screen.dart';

/// بطاقة عنصر المكتبة
class LibraryItemCard extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const LibraryItemCard({
    super.key,
    required this.item,
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
          child: Row(
            children: [
              // أيقونة نوع الملف
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: item.color,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // معلومات الملف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // المؤلف والنوع
                    Row(
                      children: [
                        Text(
                          item.author,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // الحجم وعدد الصفحات
                    Row(
                      children: [
                        Text(
                          item.size,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.pages} صفحة',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: item.isFavorite 
                      ? Theme.of(context).colorScheme.error 
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: (e) {
                  // منع انتشار الحدث إلى InkWell
                  e.stopPropagation();
                  onFavoriteTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
