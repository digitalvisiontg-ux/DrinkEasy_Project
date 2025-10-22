bool obscure = true;
bool remember = false;
bool loading = false;

// Simple validation d'email
String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Veuillez entrer votre e-mail';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(v.trim())) return 'E-mail invalide';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un mot de passe';
  }
  if (value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  }
  return null;
}
