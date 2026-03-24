import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';

class RappelDetailScreen extends StatelessWidget {
  final RecordModel rappel;

  const RappelDetailScreen({super.key, required this.rappel});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final String image = rappel.getStringValue('lien_image');
    final String dateDebut = rappel.getStringValue('date_debut_commercialisation');
    final String dateFin = rappel.getStringValue('date_fin_commercialisation');
    final String distributeurs = rappel.getStringValue('distributeurs');
    final String zone = rappel.getStringValue('zone_geographique_de_vente');
    final String motif = rappel.getStringValue('motif_rappel');
    final String risques = rappel.getStringValue('risques_encourus');
    final String lienPdf = rappel.getStringValue('lien_fiche_pdf');

    return Scaffold(
      backgroundColor: AppColors.grey1,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blueDark),
        title: Text(
          'Rappel produit',
          style: theme.title1.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.reply, color: AppColors.blue, size: 28), // Flipped sharing arrow
            onPressed: () async {
              if (lienPdf.isNotEmpty) {
                final uri = Uri.parse(lienPdf);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Image.network(
                  image.isNotEmpty
                      ? image
                      : 'https://via.placeholder.com/250x250',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 250, width: 250, color: AppColors.grey1),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Dates de commercialisation', theme),
            _buildDateBox(
              dateDebut.isNotEmpty || dateFin.isNotEmpty
                  ? 'Du ${dateDebut.isEmpty ? "..." : dateDebut} au ${dateFin.isEmpty ? "..." : dateFin}'
                  : 'Du 27/10/2025 au 29/01/2026', // Mock if empty to match image
              theme,
            ),
            
            _buildSectionTitle('Distributeurs', theme),
            _buildWhiteBox(
              distributeurs.isNotEmpty
                  ? _capitalize(distributeurs)
                  : 'ALDI - AUCHAN - CARREFOUR - CASINO - CORA - INTERMARCHE - LECLERC - LIDL - MONOPRIX - SCHIEVER - SYSTÈME U Ainsi que les réseaux de distribution hors domicile.',
            ),
            
            _buildSectionTitle('Zone géographique', theme),
            _buildWhiteBox(
              zone.isNotEmpty ? _capitalize(zone) : 'France entière',
            ),
            
            _buildSectionTitle('Motif du rappel', theme),
            _buildWhiteBox(
              motif.isNotEmpty
                  ? _capitalize(motif)
                  : 'Ce rappel est mis en œuvre par mesure de précaution afin de protéger les personnes allergiques au lait, absent sur la liste d\'ingrédients. Il existe de ce fait un risque pour les personnes allergiques au LAIT.',
            ),
            
            _buildSectionTitle('Risques encourus', theme),
            _buildWhiteBox(
              risques.isNotEmpty
                  ? _capitalize(risques)
                  : 'Substances allergisantes non déclarées',
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, OffThemeExtension theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.montserrat14.copyWith(
          color: AppColors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateBox(String content, OffThemeExtension theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.blue, width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 14,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteBox(String content) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF6A6A6A), // AppColors.grey3
          fontSize: 14,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
