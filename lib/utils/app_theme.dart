import 'package:flutter/material.dart';

/// Systeme de design premium de Hotel Smart : palette bleu nuit / or,
/// typographie Playfair Display (titres) + Manrope (texte courant).
///
/// Les polices sont embarquees localement (`assets/fonts/`) plutot que
/// chargees a la volee (`google_fonts` telecharge depuis fonts.gstatic.com
/// au premier lancement) : la meme exigence de fiabilite hors-ligne que
/// pour l'API des nationalites s'applique a l'identite visuelle - elle ne
/// doit jamais dependre d'un reseau disponible.
///
/// Toutes les couleurs de l'application doivent passer par cette classe :
/// aucune couleur ad hoc ne doit etre introduite ailleurs, pour garantir
/// une identite de marque hoteliere coherente sur tous les ecrans.
class AppTheme {
  AppTheme._();

  static const String policeTitres = 'PlayfairDisplay';
  static const String policeCorps = 'Manrope';

  /// Style Playfair Display (titres d'ecran, montants cles, wordmark).
  static TextStyle playfair({
    Color? color,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w600,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: policeTitres,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  /// Style Manrope (texte courant, labels, boutons).
  static TextStyle manrope({
    Color? color,
    double? fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: policeCorps,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  // --- Palette signature ---
  static const Color bleuNuitProfond = Color(0xFF0A1628);
  static const Color bleuNuitSurface = Color(0xFF122544);
  static const Color or = Color(0xFFC9A961);
  static const Color orLumineux = Color(0xFFE8CF8A);
  static const Color ivoire = Color(0xFFF7F3EA);
  static const Color encre = Color(0xFF16223A);
  static const Color bordeaux = Color(0xFF8C2F39);

  // Couleurs semantiques derivees de la palette (statuts), pour eviter
  // toute couleur Material generique (vert/orange neon) hors marque.
  //
  // Valeurs choisies (et assombries au besoin) pour garantir un contraste
  // texte suffisant sur fond ivoire (>= 4.5:1, seuil WCAG AA texte normal) :
  // l'or decoratif (#C9A961) n'offre qu'environ 2:1 sur ivoire et n'est
  // donc jamais utilise comme couleur de texte, y compris pour le statut
  // "alerte" qui utilise un ton bronze plus fonce derive de la meme teinte.
  static const Color succes = Color(0xFF3F6B4E);
  static const Color alerte = Color(0xFF7A5F30);
  static const Color danger = bordeaux;
  static const Color neutre = Color(0xFF565D6B);

  /// Variante claire de [bordeaux], utilisee pour les messages d'erreur
  /// sur fond bleu nuit (bordeaux pur y offrirait un contraste insuffisant).
  static const Color dangerClair = Color(0xFFD98089);

  static const LinearGradient degradeOr = LinearGradient(
    colors: [or, orLumineux],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient degradeBleuNuit = LinearGradient(
    colors: [bleuNuitProfond, bleuNuitSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Construit la typographie : Playfair Display pour les titres (display*,
  /// headline*, titleLarge), Manrope pour le reste (texte courant, labels,
  /// boutons).
  static TextTheme _texteAvecCouleurs(Brightness brightness, Color couleurTitre, Color couleurCorps) {
    final corps = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: policeCorps,
          bodyColor: couleurCorps,
          displayColor: couleurTitre,
        );
    TextStyle? titre(TextStyle? style) => style?.copyWith(fontFamily: policeTitres, fontWeight: FontWeight.w600);
    return corps.copyWith(
      displayLarge: titre(corps.displayLarge),
      displayMedium: titre(corps.displayMedium),
      displaySmall: titre(corps.displaySmall),
      headlineLarge: titre(corps.headlineLarge),
      headlineMedium: titre(corps.headlineMedium),
      headlineSmall: titre(corps.headlineSmall),
      titleLarge: titre(corps.titleLarge),
    );
  }

  /// Theme "clair" : fond ivoire, textes encre, app bars et accents bleu
  /// nuit/or - l'identite de marque de jour.
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      brightness: Brightness.light,
      primary: bleuNuitProfond,
      onPrimary: ivoire,
      secondary: or,
      onSecondary: bleuNuitProfond,
      error: bordeaux,
      onError: ivoire,
      surface: Colors.white,
      onSurface: encre,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ivoire,
      textTheme: _texteAvecCouleurs(Brightness.light, encre, encre),
      appBarTheme: AppBarTheme(
        backgroundColor: bleuNuitProfond,
        foregroundColor: ivoire,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTheme.playfair(color: ivoire, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: orLumineux),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: or,
          foregroundColor: bleuNuitProfond,
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: bleuNuitProfond,
          side: const BorderSide(color: or, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: bleuNuitProfond,
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: or,
        foregroundColor: bleuNuitProfond,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: AppTheme.manrope(color: encre.withValues(alpha: 0.65)),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x3316223A))),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x3316223A))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: or, width: 2)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: bordeaux)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: bordeaux, width: 2)),
        filled: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: encre.withValues(alpha: 0.08)),
        ),
      ),
      dividerTheme: DividerThemeData(color: encre.withValues(alpha: 0.1), space: 32),
      dialogTheme: DialogThemeData(
        backgroundColor: ivoire,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        titleTextStyle: AppTheme.playfair(color: encre, fontSize: 20, fontWeight: FontWeight.w600),
        contentTextStyle: AppTheme.manrope(color: encre),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: encre.withValues(alpha: 0.05),
        selectedColor: or.withValues(alpha: 0.18),
        labelStyle: AppTheme.manrope(color: encre, fontWeight: FontWeight.w600, fontSize: 12),
        side: BorderSide(color: encre.withValues(alpha: 0.12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      tabBarTheme: const TabBarThemeData(labelColor: or, indicatorColor: or),
    );
  }

  /// Theme "sombre" : reprend l'identite bleu nuit de l'ecran de connexion
  /// sur toute l'application, plutot qu'un mode sombre Material generique.
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: or,
      onPrimary: bleuNuitProfond,
      secondary: orLumineux,
      onSecondary: bleuNuitProfond,
      error: AppTheme.dangerClair,
      onError: bleuNuitProfond,
      surface: bleuNuitSurface,
      onSurface: ivoire,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bleuNuitProfond,
      textTheme: _texteAvecCouleurs(Brightness.dark, ivoire, ivoire.withValues(alpha: 0.92)),
      appBarTheme: AppBarTheme(
        backgroundColor: bleuNuitProfond,
        foregroundColor: ivoire,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTheme.playfair(color: ivoire, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: orLumineux),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: or,
          foregroundColor: bleuNuitProfond,
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ivoire,
          side: const BorderSide(color: or, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: orLumineux,
          textStyle: AppTheme.manrope(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: or,
        foregroundColor: bleuNuitProfond,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: AppTheme.manrope(color: ivoire.withValues(alpha: 0.65)),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x33F7F3EA))),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x33F7F3EA))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: or, width: 2)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.dangerClair)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.dangerClair, width: 2)),
        filled: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: bleuNuitSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: or.withValues(alpha: 0.15)),
        ),
      ),
      dividerTheme: DividerThemeData(color: ivoire.withValues(alpha: 0.12), space: 32),
      dialogTheme: DialogThemeData(
        backgroundColor: bleuNuitSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        titleTextStyle: AppTheme.playfair(color: ivoire, fontSize: 20, fontWeight: FontWeight.w600),
        contentTextStyle: AppTheme.manrope(color: ivoire),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ivoire.withValues(alpha: 0.06),
        selectedColor: or.withValues(alpha: 0.22),
        labelStyle: AppTheme.manrope(color: ivoire, fontWeight: FontWeight.w600, fontSize: 12),
        side: BorderSide(color: ivoire.withValues(alpha: 0.14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      tabBarTheme: const TabBarThemeData(labelColor: or, indicatorColor: or),
    );
  }
}
