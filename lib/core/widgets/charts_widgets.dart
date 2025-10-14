import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

class PieChartWidget extends StatelessWidget {
  final String title;
  final List<String> labels;
  final List<int> values;
  const PieChartWidget({super.key, required this.title, required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final colors = [HexColor('#D9BBA9'), HexColor('#8C6E58'), HexColor('#718096')];
    return Column(
      children: [
        // Pie Chart
        SizedBox(
          height: 120,
          width: 120,
          child: PieChart(
            PieChartData(
              sections: List.generate(values.length, (index) {
                return PieChartSectionData(
                  value: values[index].toDouble(),
                  showTitle: false,
                  color: colors[index].withValues(alpha: 0.6),
                  radius: 20,
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Chart Title
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor,
          ),
        ),
        const SizedBox(height: 8),
        // Row for Labels and Values
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(labels.length, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors[index].withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${labels[index]}: ${values[index]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List xyValues, xTitles;
  const BarChartWidget({super.key, required this.xyValues, required this.xTitles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.height * 0.25,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(xTitles[value.toInt()-1]),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.grey),
              left: BorderSide(color: Colors.grey),
            ),
          ),
          barGroups: [
            ...xyValues.map((e) {
              return BarChartGroupData(
                x: e['x']!,
                barRods: [
                  BarChartRodData(
                    toY: e['y']!.toDouble(),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade700,
                        Colors.cyan,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List xyValues, xTitles;
  const LineChartWidget({super.key, required this.xyValues, required this.xTitles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: context.width,
      height: context.height * 0.25,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  switch(value == value.floor()) {
                    case true:
                      return Text(xTitles[value.toInt() - 1]);
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.grey),
              left: BorderSide(color: Colors.grey),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: xyValues.map((e) => FlSpot(e['x']!.toDouble(), e['y']!.toDouble())).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.3),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class PieCharCenterTitletWidget extends StatefulWidget {
  final List<String> labels;
  final List<int> values;
  final List<Color> colors;

  const PieCharCenterTitletWidget({
    super.key,
    required this.labels,
    required this.values,
    required this.colors,
  });

  @override
  State<PieCharCenterTitletWidget> createState() => _PieCharCenterTitletWidgetState();
}

class _PieCharCenterTitletWidgetState extends State<PieCharCenterTitletWidget> {
  String title = '';
  @override
  Widget build(BuildContext context) {
    final total = widget.values.reduce((a, b) => a + b);
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: List.generate(widget.values.length, (index) {
                return PieChartSectionData(
                  value: widget.values[index].toDouble(),
                  color: widget.colors[index],
                  showTitle: false,
                  radius: 25,
                );
              }),
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              pieTouchData: PieTouchData(
                touchCallback: (touchEvent, pieTouchResponse) {
                  if (pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                    final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    final percentage = (widget.values[index] / total) * 100;
                    setState(() {
                      title = '${percentage.toInt()} %';
                    });
                  }
                },
              ),
            ),
          ),
          // Center Title
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}