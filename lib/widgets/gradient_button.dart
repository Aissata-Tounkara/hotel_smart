import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Bouton d'action principale signature de Hotel Smart : degrade or, coins
/// legerement arrondis (jamais de bouton "pilule"). A utiliser pour toute
/// action principale (se connecter, enregistrer, confirmer...).
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final desactive = onPressed == null || loading;

    return Opacity(
      opacity: desactive && !loading ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            gradient: AppTheme.degradeOr,
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: loading ? null : onPressed,
            child: Center(
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.bleuNuitProfond),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppTheme.bleuNuitProfond, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTheme.manrope(
                            color: AppTheme.bleuNuitProfond,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
