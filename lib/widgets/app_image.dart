import 'package:flutter/material.dart';

/// Asset d'image redimensionné pour éviter de décoder sa résolution complète.
class AppImage extends StatelessWidget {
  const AppImage({
    required this.assetName,
    required this.semanticLabel,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    super.key,
  }) : assert(semanticLabel != '');

  final String assetName;
  final String semanticLabel;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (width * pixelRatio).ceil();
    final cacheHeight = (height * pixelRatio).ceil();

    return Semantics(
      image: true,
      label: semanticLabel,
      child: Image.asset(
        assetName,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: width,
          height: height,
          child: const ColoredBox(
            color: Color(0xFFECE8DF),
            child: Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
