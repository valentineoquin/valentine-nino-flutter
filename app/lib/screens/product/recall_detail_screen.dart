import 'package:flutter/material.dart';
import 'package:formation_flutter/recall_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecallDetailScreen extends StatelessWidget {
  const RecallDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recall = context.read<RecallProvider>().currentRecall;

    if (recall == null) {
      return const Scaffold(
        body: Center(child: Text("Aucune donnée disponible")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche de rappel"),
        actions: [
          if (recall.getStringValue('fiche_url').isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => launchUrl(Uri.parse(recall.getStringValue('fiche_url'))),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recall.getStringValue('image_url').isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  recall.getStringValue('image_url'),
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(
                    title: recall.getStringValue('libelle'),
                    subtitle: recall.getStringValue('marque'),
                  ),
                  const SizedBox(height: 24),
                  _SectionBlock(
                    title: "Motif du rappel",
                    content: recall.getStringValue('motif'),
                    icon: Icons.info_outline,
                  ),
                  _SectionBlock(
                    title: "Risques encourus",
                    content: recall.getStringValue('risques'),
                    icon: Icons.warning_amber_rounded,
                    isCritical: true,
                  ),
                  _SectionBlock(
                    title: "Description du produit",
                    icon: Icons.inventory_2_outlined,
                    child: Column(
                      children: [
                        _DetailRow("GTIN", recall.getStringValue('gtin')),
                        _DetailRow("Catégorie", recall.getStringValue('categorie')),
                        _DetailRow("Sous-catégorie", recall.getStringValue('sous_categorie')),
                      ],
                    ),
                  ),
                  _SectionBlock(
                    title: "Informations complémentaires",
                    content: "Publié le : ${recall.getStringValue('date_publication')}",
                    icon: Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderSection({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final Widget? child;
  final bool isCritical;

  const _SectionBlock({
    required this.title,
    this.content,
    required this.icon,
    this.child,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCritical ? const Color(0xFFA60000) : Colors.blueGrey[800];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCritical ? color?.withOpacity(0.05) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: isCritical ? Border.all(color: color!.withOpacity(0.2)) : null,
            ),
            child: child ?? Text(
              content ?? "Non spécifié",
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value.isEmpty ? "-" : value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}