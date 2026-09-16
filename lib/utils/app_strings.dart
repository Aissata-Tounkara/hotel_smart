/// Petit dictionnaire de traduction FR/AR pour les libelles cles de
/// l'application (connexion, tableau de bord, parametres, profil).
///
/// Choix de conception : une traduction exhaustive de tous les ecrans
/// depasserait le cadre du cahier des charges dans le temps imparti. Ce
/// dictionnaire couvre les ecrans principaux (connexion, dashboard,
/// parametres, profil) pour demontrer un changement de langue reellement
/// fonctionnel (texte + sens de lecture RTL), le reste de l'application
/// reste en francais.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _dictionnaire = {
    'hotel_smart': {'fr': 'Hotel Smart', 'ar': 'فندق سمارت'},
    'le_palace_alger': {'fr': 'Le Palace - Alger', 'ar': 'لو بالاس - الجزائر'},
    'email': {'fr': 'Email', 'ar': 'البريد الإلكتروني'},
    'mot_de_passe': {'fr': 'Mot de passe', 'ar': 'كلمة المرور'},
    'se_connecter': {'fr': 'Se connecter', 'ar': 'تسجيل الدخول'},
    'tableau_de_bord': {'fr': 'Tableau de bord', 'ar': 'لوحة التحكم'},
    'bienvenue': {'fr': 'Bienvenue', 'ar': 'مرحبا'},
    'acces_rapide': {'fr': 'Acces rapide', 'ar': 'وصول سريع'},
    'chambres': {'fr': 'Chambres', 'ar': 'الغرف'},
    'reservations': {'fr': 'Reservations', 'ar': 'الحجوزات'},
    'clients': {'fr': 'Clients', 'ar': 'العملاء'},
    'paiements': {'fr': 'Paiements', 'ar': 'المدفوعات'},
    'utilisateurs': {'fr': 'Utilisateurs', 'ar': 'المستخدمون'},
    'statistiques': {'fr': 'Statistiques', 'ar': 'الإحصائيات'},
    'mes_reservations': {'fr': 'Mes reservations', 'ar': 'حجوزاتي'},
    'mon_profil': {'fr': 'Mon profil', 'ar': 'ملفي الشخصي'},
    'parametres': {'fr': 'Parametres', 'ar': 'الإعدادات'},
    'theme': {'fr': 'Theme', 'ar': 'المظهر'},
    'theme_clair': {'fr': 'Clair', 'ar': 'فاتح'},
    'theme_sombre': {'fr': 'Sombre', 'ar': 'داكن'},
    'theme_systeme': {'fr': 'Systeme', 'ar': 'النظام'},
    'langue': {'fr': 'Langue', 'ar': 'اللغة'},
    'deconnexion': {'fr': 'Deconnexion', 'ar': 'تسجيل الخروج'},
    'nom': {'fr': 'Nom', 'ar': 'الاسم'},
    'nouveau_mot_de_passe': {'fr': 'Nouveau mot de passe', 'ar': 'كلمة مرور جديدة'},
    'confirmer_mot_de_passe': {'fr': 'Confirmer le mot de passe', 'ar': 'تأكيد كلمة المرور'},
    'enregistrer': {'fr': 'Enregistrer', 'ar': 'حفظ'},
  };

  static String get(String cle, {required bool arabe}) {
    final entree = _dictionnaire[cle];
    if (entree == null) return cle;
    return entree[arabe ? 'ar' : 'fr'] ?? entree['fr']!;
  }
}
