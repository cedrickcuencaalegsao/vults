import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RecentTranscationCard extends StatefulWidget {
  final double padding;
  final double height;
  final double widget;
  final String title;
  final String? amount;
  final Color? amountColor;
  final String? date;
  final IconData cardIcon;
  const RecentTranscationCard({
    super.key,
    required this.padding,
    required this.height,
    required this.widget,
    required this.title,
    required this.amount,
    required this.amountColor,
    required this.date,
    required this.cardIcon,
  });

  @override
  RecentTranscationCardState createState() => RecentTranscationCardState();
}

class RecentTranscationCardState extends State<RecentTranscationCard> {
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
      return '₱ $amount';
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
          color:
              HSLColor.fromColor(
                ConstantString.lightGrey,
              ).withLightness(0.85).toColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(widget.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.cardIcon, color: widget.amountColor, size: 30),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontFamily: ConstantString.fontFredokaOne,
                          fontSize: 25,
                          color: ConstantString.darkGrey,
                        ),
                      ),
                      Text(
                        widget.date!,
                        style: const TextStyle(
                          fontFamily: ConstantString.fontFredokaOne,
                          fontSize: 12,
                          color: ConstantString.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(  // Added Expanded for flexible space
              flex: 2,
              child: AutoSizeText(  // Changed from FittedBox to AutoSizeText
                'PHP.${formatAmount(widget.amount!)}',
                style: TextStyle(
                  color: widget.amountColor,
                  fontSize: 20,  // This is now the maximum font size
                  fontFamily: ConstantString.fontFredokaOne,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                minFontSize: 12,  // Won't go smaller than this
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
              ),
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: ConstantString.darkGrey,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
