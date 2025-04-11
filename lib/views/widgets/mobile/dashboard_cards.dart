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

  const DashboardCards({
    super.key,
    required this.padding,
    required this.height,
    required this.widget,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  DashboardCardsState createState() => DashboardCardsState();
}

class DashboardCardsState extends State<DashboardCards> {
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

  final List<ChartData> chartData = [
    ChartData('Income', 60, ConstantString.green),
    ChartData('Expense', 40, ConstantString.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Container(
        height: widget.height,
        width: widget.widget,
        decoration: BoxDecoration(
          color:
              HSLColor.fromColor(
                ConstantString.lightGrey,
              ).withLightness(0.85).toColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                        size: 20.00,
                      ),
                      onPressed: () {
                        // Handle the action when the icon is pressed
                      },
                    ),
                ],
              ),
              const SizedBox(height: 3),

              if (widget.title == 'Statistics')
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
                    legend: Legend(
                      isVisible: true,
                      position:
                          LegendPosition
                              .bottom, // Changed from 'inside' to 'bottom'
                      orientation: LegendItemOrientation.horizontal,
                      alignment: ChartAlignment.center,
                      textStyle: const TextStyle(
                        fontFamily: ConstantString.fontFredoka,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              if (widget.amount != null)
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
