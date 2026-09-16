import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Ligne de liste signature de Hotel Smart : icone + libelle + valeur,
/// bordure fine discrete (jamais de carte avec ombre grise). A utiliser
/// pour toutes les listes (chambres, reservations, clients, utilisateurs,
/// paiements...) a la place de [Card] + [ListTile] Material par defaut.
class PremiumListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const PremiumListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couleurTexte = theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface;
    final or = theme.colorScheme.secondary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: couleurTexte.withValues(alpha: 0.08))),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: or.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: or, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.manrope(fontWeight: FontWeight.w700, fontSize: 15, color: couleurTexte),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTheme.manrope(fontSize: 12.5, color: couleurTexte.withValues(alpha: 0.62)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 10), trailing!],
          ],
        ),
      ),
    );
  }
}
