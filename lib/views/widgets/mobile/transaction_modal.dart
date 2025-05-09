import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/model/transaction_model.dart';

class TransactionModal extends StatelessWidget {
  final Transaction transaction;

  const TransactionModal({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.type.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    icon: Icon(Icons.close, color: ConstantString.darkBlue),
                    iconSize: 22,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              transaction.type == TransactionType.send
                  ? "Send to:"
                  : "Received from:",
              style: TextStyle(fontSize: 16, color: ConstantString.grey),
            ),
            Text(
              transaction.type == TransactionType.send
                  ? transaction.receiverId
                  : transaction.senderId,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ConstantString.darkBlue,
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.formattedDate,
                    style: TextStyle(fontSize: 16, color: ConstantString.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.formattedAmount,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ConstantString.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ref No. ${transaction.id}',
                style: TextStyle(fontSize: 14, color: ConstantString.grey),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.cloud_download,
                    color: ConstantString.lightBlue,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.share, color: ConstantString.lightBlue),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
