import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';

class HomePageHistory extends StatelessWidget {
  const HomePageHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Mock data for the history
    final items = List.generate(5, (index) => _MockItem(
      title: 'Petits pois et carottes',
      brand: 'Cassegrain',
      nutriscoreLetter: ['A', 'C', 'D', 'E', 'E'][index % 5],
    ));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey2.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.asset(
                    'res/drawables/product_pts_pois_carottes.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(width: 100, height: 100, color: AppColors.grey1),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.title3.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.brand,
                          style: theme.altText.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getNutriscoreColor(item.nutriscoreLetter),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nutriscore : ${item.nutriscoreLetter}',
                              style: theme.altText.copyWith(
                                fontSize: 13,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getNutriscoreColor(String letter) {
    switch (letter.toUpperCase()) {
      case 'A':
        return AppColors.nutriscoreA;
      case 'B':
        return AppColors.nutriscoreB;
      case 'C':
        return AppColors.nutriscoreC;
      case 'D':
        return AppColors.nutriscoreD;
      case 'E':
        return AppColors.nutriscoreE;
      default:
        return AppColors.grey2;
    }
  }
}

class _MockItem {
  final String title;
  final String brand;
  final String nutriscoreLetter;

  _MockItem({
    required this.title,
    required this.brand,
    required this.nutriscoreLetter,
  });
}
