import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/utils/app_theme.dart';

void main() {
  test('Le theme clair utilise le bleu nuit en couleur primaire', () {
    expect(AppTheme.lightTheme.colorScheme.primary, AppTheme.bleuNuit);
  });

  test('Le theme sombre utilise l\'or en couleur primaire', () {
    expect(AppTheme.darkTheme.colorScheme.primary, AppTheme.or);
  });
}
