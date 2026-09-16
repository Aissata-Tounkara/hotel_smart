import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Champ de texte signature de Hotel Smart : bordure soulignee (jamais de
/// boite remplie generique), curseur et libelle dores. A utiliser partout
/// a la place de [TextFormField] brut.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final bool enabled;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurTexte = theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface;
    final or = theme.colorScheme.secondary;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      enabled: enabled,
      autofocus: autofocus,
      style: AppTheme.manrope(color: couleurTexte, fontSize: 15),
      cursorColor: or,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: or, size: 20) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
