import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class SendmoneyFirstScreen extends StatefulWidget {
  const SendmoneyFirstScreen({super.key});

  @override
  SendmoneyFirstScreenState createState() => SendmoneyFirstScreenState();
}

class SendmoneyFirstScreenState extends State<SendmoneyFirstScreen> {
  String selectedAccount = "Savings"; // Default selected account

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send Money',
        iconColor: Color(0xFF0A0043),
        fontColor: Color(0xFF0A0043),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ConstantString.lightBlue, ConstantString.darkBlue],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20,
            ), // adds left, right, bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Send Express logo and text
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.send_outlined,
                        color: ConstantString.white,
                        size: 75,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Send Express',
                        style: TextStyle(
                          color: ConstantString.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Account number field
                Text(
                  'Account number:',
                  style: TextStyle(
                    color: ConstantString.white,
                    fontSize: 18,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: ConstantString.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Amount field
                Text(
                  'Amount:',
                  style: TextStyle(
                    color: ConstantString.white,
                    fontSize: 18,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: ConstantString.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Send Money from section
                Text(
                  'Send Money from:',
                  style: TextStyle(
                    color: ConstantString.white,
                    fontSize: 18,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 10),

                // Account option - Fix Deposit
                _buildAccountOption(
                  "Fix Deposit",
                  "Fix Deposit" == selectedAccount,
                  ConstantString.lightBlue,
                ),
                const SizedBox(height: 10),

                // Account option - Savings
                _buildAccountOption(
                  "Savings",
                  "Savings" == selectedAccount,
                  ConstantString.green,
                ),
                const SizedBox(height: 10),

                // Account option - Business
                _buildAccountOption(
                  "Business",
                  "Business" == selectedAccount,
                  ConstantString.orange,
                ),
                const SizedBox(height: 10),

                // Account option - Checking
                _buildAccountOption(
                  "Checking",
                  "Checking" == selectedAccount,
                  ConstantString.darkBlue,
                ),

                const Spacer(),

                // Continue button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SendmoneySecondScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantString.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: ConstantString.darkBlue,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredokaOne,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption(String title, bool isSelected, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccount = title;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ConstantString.white,
                  fontSize: 18,
                  fontFamily: ConstantString.fontFredokaOne,
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ConstantString.white,
                  border: Border.all(color: ConstantString.white, width: 2),
                ),
                child:
                    isSelected
                        ? Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ConstantString.lightBlue,
                          ),
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendmoneySecondScreen extends StatefulWidget {
  const SendmoneySecondScreen({super.key});

  @override
  SendmoneySecondScreenState createState() => SendmoneySecondScreenState();
}

class SendmoneySecondScreenState extends State<SendmoneySecondScreen> {
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send Money',
        iconColor: Color(0xFF0A0043),
        fontColor: Color(0xFF0A0043),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.lightBlue, ConstantString.darkBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Push content apart
              children: [
                // Middle text content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'You are sending',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '{amount} to',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '0000-0000-0000,',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'ref:123456789012345.',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'You can see this transaction on the',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 20,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'transaction tab',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 20,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section: Confirmation + Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4.0,
                      ), // adds left margin
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isConfirmed,
                              onChanged: (value) {
                                setState(() {
                                  isConfirmed = value ?? false;
                                });
                              },
                              fillColor: MaterialStateProperty.all(
                                ConstantString.white,
                              ),
                              checkColor: ConstantString.lightBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'I confirm this transaction.',
                            style: TextStyle(
                              color: ConstantString.white,
                              fontSize: 16,
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle send functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantString.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: ConstantString.darkBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
