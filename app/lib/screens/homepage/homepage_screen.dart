import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/homepage/homepage_history.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Toggle this to see empty vs history states. Set to true by default for demo.
  bool _hasHistory = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Mes scans',
          style: theme.title1.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          if (_hasHistory) // Barcode only appears when there is history
            IconButton(
              onPressed: () => _onScanButtonPressed(context),
              icon: const Icon(AppIcons.barcode, color: AppColors.blue, size: 28),
            ),
          IconButton(
            onPressed: () => context.push('/favorites'),
            icon: const Icon(Icons.star, color: AppColors.blue, size: 28),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                // Toggle state for demonstration purposes
                setState(() {
                  _hasHistory = !_hasHistory;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _hasHistory
          ? const HomePageHistory()
          : HomePageEmpty(onScan: () => _onScanButtonPressed(context)),
    );
  }

  Future<void> _onScanButtonPressed(BuildContext context) async {
    final String? res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );

    if (res != null && res is String && res != '-1' && res.isNotEmpty) {
      if (context.mounted) {
        context.push('/product', extra: res);
      }
    }
  }
}

