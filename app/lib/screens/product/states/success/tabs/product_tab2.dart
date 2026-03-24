import 'package:flutter/material.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Repères nutritionnels pour 100g',
              style: TextStyle(
                color: Color(0xFF6A6A6A), // AppColors.grey3
                fontSize: 14,
                fontFamily: 'Avenir',
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildNutritionRow(
            'Matières grasses / lipides',
            '0,8g',
            'Faible quantité',
            const Color(0xFF63993F), // nutrientLevelLow
          ),
          const Divider(color: Color(0xFFF6F6F8), height: 32, thickness: 1),
          _buildNutritionRow(
            'Acides gras saturés',
            '0,1g',
            'Faible quantité',
            const Color(0xFF63993F),
          ),
          const Divider(color: Color(0xFFF6F6F8), height: 32, thickness: 1),
          _buildNutritionRow(
            'Sucres',
            '5,2g',
            'Quantité modérée',
            const Color(0xFF997B3F), // nutrientLevelModerate
          ),
          const Divider(color: Color(0xFFF6F6F8), height: 32, thickness: 1),
          _buildNutritionRow(
            'Sel',
            '0,75g',
            'Quantité élevée',
            const Color(0xFF993F3F), // nutrientLevelHigh
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String levelLabel, Color levelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
               color: Color(0xFF080040), // AppColors.blue
               fontSize: 14,
               fontWeight: FontWeight.w600,
               fontFamily: 'Avenir',
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: levelColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Avenir',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              levelLabel,
              style: TextStyle(
                color: levelColor,
                fontSize: 12,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
