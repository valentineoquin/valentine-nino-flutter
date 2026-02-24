import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class RecallProvider extends ChangeNotifier {
  // L'URL dépend de ton environnement (127.0.0.1 pour Web, 10.0.2.2 pour Android)
  final pb = PocketBase('http://127.0.0.1:8090');

  // Déclaration de la variable privée
  RecordModel? _currentRecall;

  // Getter pour lire la valeur depuis l'extérieur
  RecordModel? get currentRecall => _currentRecall;

  Future<void> searchByGtin(String gtin) async {
    try {
      final cleanGtin = gtin.trim();

      // On cherche dans la collection 'recalls'
      final result = await pb.collection('recalls').getFirstListItem(
        'gtin = "$cleanGtin"',
      );

      _currentRecall = result;
      notifyListeners();
      print("Succès : Rappel trouvé pour $cleanGtin");
    } catch (e) {
      _currentRecall = null;
      notifyListeners();

      if (e.toString().contains('404')) {
        print("Info PocketBase : Aucun rappel pour le GTIN $gtin");
      } else {
        print("Erreur PocketBase : $e");
      }
    }
  }

  // Cette fonction doit être à l'intérieur de la classe !
  void clearSearch() {
    _currentRecall = null; // On utilise la variable privée avec le underscore
    notifyListeners();
  }
}