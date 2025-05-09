import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class DashboardCards extends StatefulWidget {
  final double padding;
  final double height;
  final double widget;
  final String title;
  final String? amount;
  final Color? amountColor;
  final Map<String, dynamic>? statistics; // Added

  const DashboardCards({
    super.key,
    required this.padding,
    required this.height,
    required this.widget,
    required this.title,
    required this.amount,
    required this.amountColor,
    this.statistics, // Added
  });

  @override
  DashboardCardsState createState() => DashboardCardsState();
}

class DashboardCardsState extends State<DashboardCards> {
  late List<ChartData> chartData;

  @override
  void initState() {
    super.initState();
    _updateChartData();
  }

  @override
  void didUpdateWidget(covariant DashboardCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statistics != oldWidget.statistics) {
      _updateChartData();
    }
  }

  void _updateChartData() {
    if (widget.title != 'Statistics' || widget.statistics == null) {
      chartData = [
        ChartData('Income', 60, ConstantString.green),
        ChartData('Expense', 40, ConstantString.red),
      ];
      return;
    }

    final stats = widget.statistics!;
    final statusCounts = stats['transactionsByStatus'] as Map<String, dynamic>? ?? {
      'completed': 0,
      'pending': 0,
      'failed': 0,
    };

    chartData = [
      ChartData('Completed', (statusCounts['completed'] ?? 0).toDouble(), ConstantString.green),
      ChartData('Pending', (statusCounts['pending'] ?? 0).toDouble(), Colors.orange),
      ChartData('Failed', (statusCounts['failed'] ?? 0).toDouble(), ConstantString.red),
    ];
  }

  String formatAmount(String amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );

    try {
      final value = double.parse(amount.replaceAll(',', ''));
      return formatter.format(value);
    } catch (e) {
      return '₱$amount';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Container(
        height: widget.height,
        width: widget.widget,
        decoration: BoxDecoration(
          color: HSLColor.fromColor(ConstantString.lightGrey)
              .withLightness(0.85)
              .toColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title & Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(widget.height * 0.01),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: ConstantString.darkBlue,
                        fontSize: 14,
                        fontFamily: ConstantString.fontFredokaOne,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.title == 'Statistics')
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: ConstantString.darkGrey,
                        size: 20.0,
                      ),
                      onPressed: () {
                        // Handle menu action
                      },
                    ),
                ],
              ),

              const SizedBox(height: 3),

              // Chart or Amount
              if (widget.title == 'Statistics')
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SfCircularChart(
                          margin: EdgeInsets.zero,
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource: chartData,
                              pointColorMapper: (ChartData data, _) => data.color,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: ConstantString.fontFredoka,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                labelIntersectAction: LabelIntersectAction.shift,
                              ),
                              enableTooltip: true,
                              radius: '120%',
                              explode: true,
                              explodeIndex: 0,
                              strokeWidth: 1,
                              strokeColor: Colors.white,
                            ),
                          ],
                          legend: const Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            orientation: LegendItemOrientation.horizontal,
                            alignment: ChartAlignment.center,
                            textStyle: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (widget.statistics != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Total: ${widget.statistics!['totalTransactions']} transactions\n'
                            'Amount: ₱${(widget.statistics!['totalAmount'] as double).toStringAsFixed(2)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              else if (widget.amount != null)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${widget.title == 'Cash In' ? '+ PHP.' : '- PHP.'} ${formatAmount(widget.amount!)}',
                    style: TextStyle(
                      color: widget.amountColor,
                      fontSize: 20,
                      fontFamily: ConstantString.fontFredokaOne,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
