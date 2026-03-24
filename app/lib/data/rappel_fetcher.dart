import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

/// ChangeNotifier qui vérifie si un produit (par code-barres) fait l'objet
/// d'un rappel dans PocketBase.
///
/// Fonctionne sur le même modèle que ProductFetcher :
/// - On lui donne un code-barres
/// - Il interroge PocketBase
/// - Il expose l'état (isLoading, hasRappel, rappel)

class RappelFetcher extends ChangeNotifier {
  // Connexion à PocketBase
  // - 10.0.2.2 sur Android Emulator (pour accéder au localhost de l'ordi)
  // - 127.0.0.1 (localhost) sur Windows, iOS, Web
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8090';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8090';
    } catch (_) {}
    return 'http://127.0.0.1:8090';
  }

  final PocketBase pb = PocketBase(baseUrl);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasRappel = false;
  bool get hasRappel => _hasRappel;

  RecordModel? _rappel;
  RecordModel? get rappel => _rappel;

  String? _error;
  String? get error => _error;

  /// Recherche si un code-barres donné a un rappel produit dans PocketBase.
  Future<void> checkRappel(String codeBarres) async {
    _isLoading = true;
    _hasRappel = false;
    _rappel = null;
    _error = null;
    notifyListeners();

    try {
      // Rechercher dans la collection "recalls" les entrées avec ce GTIN
      final result = await pb
          .collection('recalls')
          .getList(page: 1, perPage: 1, filter: 'gtin = "$codeBarres"');

      if (result.items.isNotEmpty) {
        _hasRappel = true;
        _rappel = result.items.first;
      } else {
        _hasRappel = false;
        _rappel = null;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Erreur lors de la vérification du rappel: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
