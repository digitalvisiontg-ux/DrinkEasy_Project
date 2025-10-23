bool obscure = true;
bool remember = false;
bool loading = false;

/// 🔹 Validation de l'adresse e-mail
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Veuillez entrer votre e-mail';
  }

  // Expression régulière plus stricte pour les e-mails
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!emailRegex.hasMatch(value.trim())) {
    return 'Adresse e-mail invalide';
  }

  return null;
}

/// 🔹 Validation du mot de passe
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un mot de passe';
  }
  if (value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  }
  return null;
}

/// 🔹 Validation du numéro de téléphone
/// Accepte :
///   - +22898472701
///   - 98472701
///   - 0022898472701
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Veuillez entrer votre numéro de téléphone';
  }

  final phoneRegex = RegExp(r'^(?:\+228|00228)?\d{8}$');

  if (!phoneRegex.hasMatch(value.trim())) {
    return 'Numéro de téléphone invalide (ex: +22898472701 ou 98472701)';
  }

  return null;
}

/// 🔹 Validation mixte pour connexion (email OU téléphone)
String? validateLogin(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Veuillez entrer votre e-mail ou numéro de téléphone';
  }

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  final phoneRegex = RegExp(r'^(?:\+228|00228)?\d{8}$');

  if (!emailRegex.hasMatch(value.trim()) && !phoneRegex.hasMatch(value.trim())) {
    return 'Entrez un e-mail ou un numéro de téléphone valide';
  }

  return null;
}

