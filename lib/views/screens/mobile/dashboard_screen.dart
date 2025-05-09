import 'package:flutter/material.dart';
import 'package:vults/views/widgets/mobile/dashboard_appbar.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/account_card.dart';
import 'package:vults/views/widgets/mobile/dashboard_cards.dart';
import 'package:vults/views/widgets/mobile/recent_transcation_card.dart';
import 'package:vults/core/service/service.dart';
import 'package:vults/model/user_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 1.0, // Show only one card at a time
    initialPage: 0,
  );
  int _currentPage = 0;
  User? currentuser;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    _fetUserData();
  }

  void _fetUserData() async {
    try {
      currentuser = await _authService.getCurrentUser();
      debugPrint("Current User ID: ${currentuser?.userAccounts}");
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? ConstantString.white : ConstantString.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void navigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;

    List<Map<String, String>> accountCards = [];
    if (currentuser != null && currentuser!.userAccounts.isNotEmpty) {
      accountCards =
          currentuser!.userAccounts.map<Map<String, String>>((account) {
            final Map<String, dynamic> map = Map<String, dynamic>.from(account);
            final accountId = map['account_id'].toString();
            map.remove('account_id'); // Now only one key like 'savings', etc.
            final accountType = map.keys.first;
            final balance = map[accountType].toString();

            return {
              'type': accountType == 'fixed_deposit'
                  ? 'Fixed Deposit'
                  : accountType == 'savings'
                      ? 'Savings'
                      : accountType == 'business'
                          ? 'Business'
                          : 'Checking',
              'balance': balance,
              'number': accountId,
            };
          }).toList();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const DashboardAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ConstantString.lightBlue, ConstantString.darkBlue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: ConstantString.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    currentuser != null
                        ? '${currentuser!.firstName} ${currentuser!.lastName}'
                        : 'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: ConstantString.fontFredokaOne,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Text(
                    currentuser != null
                        ? 'Joined: ${DateFormat('yyyy-MM-dd').format(currentuser!.createdAt)}'
                        : 'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            ListTile(
              leading: const Icon(
                Icons.dashboard_rounded,
                color: ConstantString.darkBlue,
                size: 50,
              ),
              title: const Text(
                ConstantString.dashboard,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: ConstantString.fontFredokaOne,
                  color: ConstantString.darkBlue,
                ),
              ),
              onTap: () => navigate("/dashboard"),
            ),
            SizedBox(height: screenWidth * 0.03),
            ListTile(
              leading: const Icon(
                Icons.currency_exchange_rounded,
                color: ConstantString.darkBlue,
                size: 50,
              ),
              title: const Text(
                ConstantString.transaction,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: ConstantString.fontFredokaOne,
                  color: ConstantString.darkBlue,
                ),
              ),
              onTap: () => navigate("/transaction"),
            ),
            SizedBox(height: screenWidth * 0.03),
            ListTile(
              leading: const Icon(
                Icons.settings_rounded,
                color: ConstantString.darkBlue,
                size: 50,
              ),
              title: const Text(
                ConstantString.settingsMenu,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: ConstantString.fontFredokaOne,
                  color: ConstantString.darkBlue,
                ),
              ),
              onTap: () => navigate("/settings"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.45,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ConstantString.lightBlue, ConstantString.darkBlue],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: padding.top + kToolbarHeight + 15),
                  SizedBox(
                    height: screenHeight * 0.255,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: accountCards.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: AccountCard(
                            accountType: accountCards[index]['type']!,
                            balance: accountCards[index]['balance']!,
                            accountNumber: accountCards[index]['number']!,
                            cardColor:
                                [
                                  ConstantString.lightBlue,
                                  ConstantString.green,
                                  ConstantString.orange,
                                  ConstantString.darkBlue,
                                ][index %
                                    4], // Use modulo to ensure index is within bounds
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.027),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      accountCards.length,
                      (index) => _buildPageIndicator(index == _currentPage),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    DashboardCards(
                      padding: screenWidth * 0.025,
                      height: screenHeight * 0.075,
                      widget: screenWidth * 0.39,
                      title: 'Cash In',
                      amount: '10000',
                      amountColor: ConstantString.green,
                    ),
                    DashboardCards(
                      padding: screenWidth * 0.025,
                      height: screenHeight * 0.075,
                      widget: screenWidth * 0.39,
                      title: 'Cash Out',
                      amount: '1000.00',
                      amountColor: ConstantString.red,
                    ),
                  ],
                ),
                DashboardCards(
                  padding: screenWidth * 0.025,
                  height: screenHeight * 0.175,
                  widget: screenWidth * 0.39,
                  title: "Statistics",
                  amount: null,
                  amountColor: null,
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Recent ${ConstantString.transaction}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: ConstantString.fontFredokaOne,
                        color: ConstantString.darkBlue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: ConstantString.darkGrey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: screenWidth * 0.03),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RecentTranscationCard(
                    padding: screenHeight * 0.01,
                    height: screenHeight * 0.09,
                    widget: screenWidth * 0.85,
                    title: "Sent",
                    amount: "123",
                    amountColor: ConstantString.red,
                    date: "March 12, 2023",
                    cardIcon: Icons.arrow_upward_rounded,
                  ),
                  RecentTranscationCard(
                    padding: screenHeight * 0.01,
                    height: screenHeight * 0.09,
                    widget: screenWidth * 0.85,
                    title: "Cash Out",
                    amount: "1000000",
                    amountColor: ConstantString.red,
                    date: "March 12, 2023",
                    cardIcon: Icons.arrow_upward_rounded,
                  ),
                  RecentTranscationCard(
                    padding: screenHeight * 0.01,
                    height: screenHeight * 0.09,
                    widget: screenWidth * 0.85,
                    title: "Received",
                    amount: "123123",
                    amountColor: ConstantString.green,
                    date: "March 12, 2023",
                    cardIcon: Icons.arrow_downward_rounded,
                  ),
                  RecentTranscationCard(
                    padding: screenHeight * 0.01,
                    height: screenHeight * 0.09,
                    widget: screenWidth * 0.85,
                    title: "Cash In",
                    amount: "123123",
                    amountColor: ConstantString.green,
                    date: "March 12, 2023",
                    cardIcon: Icons.arrow_downward_rounded,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
          ],
        ),
      ),
    );
  }
}
