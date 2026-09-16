import 'dart:math';

import 'package:flutter/material.dart';

/// Motif decoratif en eventail (rayons + arcs concentriques), inspire de
/// l'esthetique Art Deco des grands hotels. Reserve exclusivement a
/// l'ecran de connexion : ne pas le dupliquer ailleurs, il doit rester
/// l'element decoratif fort et unique de l'application.
class ArtDecoFan extends StatelessWidget {
  final double size;
  final Color color;
  final int nombreDeRayons;

  const ArtDecoFan({
    super.key,
    this.size = 260,
    required this.color,
    this.nombreDeRayons = 14,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ArtDecoFanPainter(color: color, nombreDeRayons: nombreDeRayons),
        ),
      ),
    );
  }
}

class _ArtDecoFanPainter extends CustomPainter {
  final Color color;
  final int nombreDeRayons;

  _ArtDecoFanPainter({required this.color, required this.nombreDeRayons});

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height);
    final rayon = size.width / 2;

    final traitFin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i <= nombreDeRayons; i++) {
      final angle = pi + (pi * i / nombreDeRayons);
      final extremite = Offset(
        centre.dx + rayon * cos(angle),
        centre.dy + rayon * sin(angle),
      );
      final opacite = i.isEven ? 0.28 : 0.14;
      canvas.drawLine(centre, extremite, traitFin..color = color.withValues(alpha: opacite));
    }

    for (int anneau = 1; anneau <= 3; anneau++) {
      final r = rayon * anneau / 3;
      final rect = Rect.fromCircle(center: centre, radius: r);
      canvas.drawArc(
        rect,
        pi,
        pi,
        false,
        traitFin..color = color.withValues(alpha: 0.32),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArtDecoFanPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.nombreDeRayons != nombreDeRayons;
  }
}
