import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/chambre.dart';
import '../../providers/statistics_provider.dart';
import '../../services/statistics_service.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/hero_stat_card.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

const _moisAbreges = [
  'Jan',
  'Fev',
  'Mar',
  'Avr',
  'Mai',
  'Jun',
  'Jul',
  'Aou',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<StatisticsProvider>().charger(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = context.select<StatisticsProvider, Statistique?>(
      (provider) => provider.statistiques,
    );
    final enChargement = context.select<StatisticsProvider, bool>(
      (provider) => provider.enChargement,
    );
    final occupationParMois = context
        .select<StatisticsProvider, List<OccupationMensuelle>>(
          (provider) => provider.occupationParMois,
        );
    final revenuParType = context
        .select<StatisticsProvider, List<RevenuParType>>(
          (provider) => provider.revenuParType,
        );
    final statisticsProvider = context.read<StatisticsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.statisticsTitle),
      body: enChargement && stats == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: statisticsProvider.charger,
              child: FadeSlideIn(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (stats != null) ...[
                      HeroStatCard(
                        label: l10n.revenueThisMonth,
                        value: UiHelpers.formatMontant(
                          stats.chiffreAffairesMensuel,
                        ),
                        icon: Icons.trending_up,
                      ),
                      const SizedBox(height: 14),
                      MiniStat(
                        label: l10n.occupancyRate,
                        value: '${stats.tauxOccupation.toStringAsFixed(1)}%',
                        icon: Icons.percent,
                      ),
                      const OrnamentalDivider(),
                    ],
                    Text(
                      l10n.occupancyByMonth,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: RepaintBoundary(
                        child: _GraphiqueOccupation(donnees: occupationParMois),
                      ),
                    ),
                    const OrnamentalDivider(),
                    Text(
                      l10n.revenueByRoomType,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: RepaintBoundary(
                        child: _GraphiqueRevenu(donnees: revenuParType),
                      ),
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
    if (donnees.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noData));
    }
    final couleur = Theme.of(context).colorScheme.primary;
    final couleurTexte = Theme.of(context).textTheme.bodySmall?.color;
    final resume = donnees
        .map(
          (d) => '${_moisAbreges[d.mois - 1]} : ${d.taux.toStringAsFixed(1)} %',
        )
        .join(', ');

    return Semantics(
      label: AppLocalizations.of(context)!.occupancyChartSummary(resume),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 25,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= donnees.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _moisAbreges[donnees[index].mois - 1],
                      style: TextStyle(fontSize: 11, color: couleurTexte),
                    ),
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
                barRods: [
                  BarChartRodData(
                    toY: donnees[i].taux,
                    color: couleur,
                    width: 18,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _GraphiqueRevenu extends StatelessWidget {
  final List<RevenuParType> donnees;
  const _GraphiqueRevenu({required this.donnees});

  @override
  Widget build(BuildContext context) {
    if (donnees.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noData));
    }
    final accent = Theme.of(context).colorScheme.secondary;
    final couleurTexte = Theme.of(context).textTheme.bodySmall?.color;
    final maxY = donnees
        .map((d) => d.montant)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final resume = donnees
        .map((d) => '${d.type.libelle} : ${UiHelpers.formatMontant(d.montant)}')
        .join(', ');

    return Semantics(
      label: AppLocalizations.of(context)!.revenueChartSummary(resume),
      child: BarChart(
        BarChartData(
          maxY: maxY == 0 ? 100 : maxY * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 56),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= donnees.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      donnees[index].type.libelle,
                      style: TextStyle(fontSize: 11, color: couleurTexte),
                    ),
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
                barRods: [
                  BarChartRodData(
                    toY: donnees[i].montant,
                    color: accent,
                    width: 24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
