import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../screens/rappel_detail_screen.dart';

/// Bandeau d'alerte qui s'affiche quand un produit fait l'objet d'un rappel.
///
/// Spécifications visuelles (d'après les consignes) :
/// - Couleur d'arrière-plan : #FF0000 avec opacité 36%
/// - Couleur de premier plan : #A60000 avec opacité 100%
/// - Arrondi : 12px
/// - Marges : 8px horizontal / 12px vertical
class RappelBanner extends StatelessWidget {
  final RecordModel rappel;

  const RappelBanner({super.key, required this.rappel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers l'écran de détail du rappel
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RappelDetailScreen(rappel: rappel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // #FF0000 avec 36% d'opacité (0.36 * 255 ≈ 92 = 0x5C)
          color: const Color(0x5CFF0000),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Ce produit fait l\'objet d\'un rappel produit',
                style: const TextStyle(
                  color: Color(0xFFA60000),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Color(0xFFA60000), size: 28),
          ],
        ),
      ),
    );
  }
}
