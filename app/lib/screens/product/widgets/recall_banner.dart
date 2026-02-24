import 'package:flutter/material.dart';
import 'package:formation_flutter/recall_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecallBanner extends StatelessWidget {
  const RecallBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecallProvider>(
      builder: (context, provider, child) {
        // Si pas de rappel, le widget est invisible
        if (provider.currentRecall == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: InkWell(
            onTap: () => context.push('/recall-detail'),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // #FF0000 avec 36% d'opacité
                color: const Color(0xFFFF0000).withOpacity(0.36),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  // Icône en #A60000
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFA60000)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Rappel produit : ${provider.currentRecall!.getStringValue('motif')}",
                      style: const TextStyle(
                        color: Color(0xFFA60000), // #A60000
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFA60000)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}