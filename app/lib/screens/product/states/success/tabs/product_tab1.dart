import 'package:flutter/material.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Ingrédients'),
          _buildIngredientRow('Légumes', 'petits pois 41%, carottes 22%'),
          _buildIngredientRow('Eau', ''),
          _buildIngredientRow('Sucre', ''),
          _buildIngredientRow('Garniture (2,5 %)', 'salade, oignon grelot'),
          _buildIngredientRow('Sel', ''),
          _buildIngredientRow('Arômes naturels', ''),
          const SizedBox(height: 16),
          _buildSectionTitle('Substances allergènes'),
          _buildSingleValue('Aucune'),
          const SizedBox(height: 16),
          _buildSectionTitle('Additifs'),
          _buildSingleValue('Aucune'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      color: const Color(0xFFF6F6F8), // AppColors.grey1
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF080040), // AppColors.blue
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
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
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF6A6A6A), // AppColors.grey3
                fontSize: 14,
                fontFamily: 'Avenir',
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleValue(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF080040), // AppColors.blue
          fontSize: 14,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }
}
