import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';

class TransactionModal extends StatelessWidget {
  final Map<String, String> transaction;

  const TransactionModal({Key? key, required this.transaction})
    : super(key: key);

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
                  transaction["type"]!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    icon: Icon(Icons.close, color: ConstantString.darkBlue),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Send to:",
              style: TextStyle(fontSize: 16, color: ConstantString.grey),
            ),
            Text(
              "Firstname Lastname",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ConstantString.darkBlue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "0000-0000-0000",
              style: TextStyle(fontSize: 16, color: ConstantString.grey),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction["date"]!,
                    style: TextStyle(fontSize: 16, color: ConstantString.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    transaction["amount"]!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ConstantString.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                transaction["ref"]!,
                style: TextStyle(fontSize: 14, color: ConstantString.grey),
              ),
            ),
            SizedBox(height: 20),
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
