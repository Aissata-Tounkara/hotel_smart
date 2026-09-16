/// Validateurs de formulaires reutilisables dans tous les ecrans.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9+ ]{8,15}$');

  static String? required(String? value, {String champ = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$champ est obligatoire';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "L'email est obligatoire";
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Format email invalide';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le telephone est obligatoire';
    }
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Format telephone invalide';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }
    if (value.length < minLength) {
      return 'Minimum $minLength caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value != original) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String champ = 'La valeur'}) {
    if (value == null || value.trim().isEmpty) {
      return '$champ est obligatoire';
    }
    final n = num.tryParse(value.trim());
    if (n == null || n <= 0) {
      return '$champ doit etre un nombre positif';
    }
    return null;
  }
}
