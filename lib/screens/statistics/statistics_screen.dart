import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../providers/statistics_provider.dart';
import '../../services/statistics_service.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/hero_stat_card.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

const _moisAbreges = ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Ecran Statistiques : taux d'occupation par mois et revenus par type de
/// chambre, sous forme de graphiques en barres (point 32).
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<StatisticsProvider>().charger());
  }

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = context.watch<StatisticsProvider>();
    final stats = statisticsProvider.statistiques;

    return Scaffold(
      appBar: const PremiumAppBar(title: 'Statistiques'),
      body: statisticsProvider.enChargement && stats == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: statisticsProvider.charger,
              child: FadeSlideIn(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (stats != null) ...[
                      HeroStatCard(
                        label: 'Chiffre d\'affaires du mois',
                        value: UiHelpers.formatMontant(stats.chiffreAffairesMensuel),
                        icon: Icons.trending_up,
                      ),
                      const SizedBox(height: 14),
                      MiniStat(
                        label: 'Taux d\'occupation',
                        value: '${stats.tauxOccupation.toStringAsFixed(1)}%',
                        icon: Icons.percent,
                      ),
                      const OrnamentalDivider(),
                    ],
                    Text('Taux d\'occupation par mois', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: _GraphiqueOccupation(donnees: statisticsProvider.occupationParMois),
                    ),
                    const OrnamentalDivider(),
                    Text('Revenus par type de chambre', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: _GraphiqueRevenu(donnees: statisticsProvider.revenuParType),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _GraphiqueOccupation extends StatelessWidget {
  final List<OccupationMensuelle> donnees;
  const _GraphiqueOccupation({required this.donnees});

  @override
  Widget build(BuildContext context) {
    if (donnees.isEmpty) return const Center(child: Text('Aucune donnee'));
    final couleur = Theme.of(context).colorScheme.primary;
    final couleurTexte = Theme.of(context).textTheme.bodySmall?.color;

    return BarChart(
      BarChartData(
        maxY: 100,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, interval: 25)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= donnees.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(_moisAbreges[donnees[index].mois - 1], style: TextStyle(fontSize: 11, color: couleurTexte)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        barGroups: [
          for (int i = 0; i < donnees.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: donnees[i].taux, color: couleur, width: 18, borderRadius: BorderRadius.circular(3))],
            ),
        ],
      ),
    );
  }
}

class _GraphiqueRevenu extends StatelessWidget {
  final List<RevenuParType> donnees;
  const _GraphiqueRevenu({required this.donnees});

  @override
  Widget build(BuildContext context) {
    if (donnees.isEmpty) return const Center(child: Text('Aucune donnee'));
    final accent = Theme.of(context).colorScheme.secondary;
    final couleurTexte = Theme.of(context).textTheme.bodySmall?.color;
    final maxY = donnees.map((d) => d.montant).fold<double>(0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxY == 0 ? 100 : maxY * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 56)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= donnees.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(donnees[index].type.libelle, style: TextStyle(fontSize: 11, color: couleurTexte)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        barGroups: [
          for (int i = 0; i < donnees.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: donnees[i].montant, color: accent, width: 24, borderRadius: BorderRadius.circular(3))],
            ),
        ],
      ),
    );
  }
}
