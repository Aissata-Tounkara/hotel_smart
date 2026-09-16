import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// App bar signature de Hotel Smart : degrade bleu nuit, titre en Playfair
/// Display, icones dorees. A utiliser sur tous les ecrans (hors connexion
/// et splash) a la place d'un [AppBar] Material par defaut.
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.degradeBleuNuit),
      child: AppBar(
        title: Text(
          title,
          style: AppTheme.playfair(
            color: AppTheme.ivoire,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.ivoire,
        iconTheme: const IconThemeData(color: AppTheme.orLumineux),
        actionsIconTheme: const IconThemeData(color: AppTheme.orLumineux),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
    );
  }
}
