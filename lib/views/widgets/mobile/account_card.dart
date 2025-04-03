import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';

class AccountCard extends StatefulWidget {
  final String accountType;
  final String balance;
  final String accountNumber;
  final Color cardColor; // Add card color parameter

  const AccountCard({
    super.key,
    required this.accountType,
    required this.balance,
    required this.accountNumber,
    required this.cardColor, // Default to white if not specified
  });

  @override
  AccountCardState createState() => AccountCardState();
}

class AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(10, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Php. ${widget.balance}',
                  style: const TextStyle(
                    color: ConstantString.white,
                    fontSize: 40,
                    fontFamily: ConstantString.fontFredoka,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text(
                          widget.accountType,
                          style: const TextStyle(
                            color: ConstantString.white,
                            fontSize: 35,
                            fontFamily: ConstantString.fontFredoka,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Text(
                          widget.accountNumber,
                          style: const TextStyle(
                            color: ConstantString.white,
                            fontSize: 20,
                            fontFamily: ConstantString.fontFredoka,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 90,
                        color: ConstantString.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
