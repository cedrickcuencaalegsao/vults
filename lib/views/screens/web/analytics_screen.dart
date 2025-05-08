import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vults/core/constants/constant_string.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsView> {
  String _selectedDateRange = 'Last 7 Days';
  String _selectedAccountType = 'All';

  final List<TransactionData> _transactionData = [
    TransactionData('Mon', 2500),
    TransactionData('Tue', 3200),
    TransactionData('Wed', 2800),
    TransactionData('Thu', 4100),
    TransactionData('Fri', 3700),
    TransactionData('Sat', 2900),
    TransactionData('Sun', 3500),
  ];

  final List<AccountData> _accountData = [
    AccountData('Savings', 35),
    AccountData('Checking', 25),
    AccountData('Fixed Deposit', 20),
    AccountData('Business', 20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 24),
            _buildMetricsCards(),
            const SizedBox(height: 32),
            _buildCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 20),
          label: Text(
            'Print Reports',
            style: TextStyle(fontFamily: ConstantString.fontFredoka),
          ),
          style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(100, 48),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedDateRange,
          items: ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'This Year']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedDateRange = newValue;
              });
            }
          },
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _selectedAccountType,
          items: ['All', 'Savings', 'Checking', 'Fixed Deposit', 'Business']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedAccountType = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildMetricsCards() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      childAspectRatio: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          'Total Users',
          '1,234',
          Icons.people,
          Colors.blue,
          '+12% from last month',
        ),
        _buildMetricCard(
          'Active Users',
          '987',
          Icons.person,
          Colors.green,
          '+8% from last month',
        ),
        _buildMetricCard(
          'Total Transactions',
          '5,678',
          Icons.receipt_long,
          Colors.orange,
          '+15% from last month',
        ),
        _buildMetricCard(
          'Transaction Volume',
          '234,567',
          Icons.attach_money,
          Colors.purple,
          '+20% from last month',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: ConstantString.fontFredoka,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredoka,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            trend,
            style: TextStyle(
              color: Colors.green[600],
              fontSize: 12,
              fontFamily: ConstantString.fontFredoka,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries<TransactionData, String>>[
                      AreaSeries<TransactionData, String>(
                        dataSource: _transactionData,
                        xValueMapper: (TransactionData data, _) => data.day,
                        yValueMapper: (TransactionData data, _) => data.amount,
                        gradient: LinearGradient(
                          colors: [
                            ConstantString.lightBlue.withOpacity(0.3),
                            ConstantString.lightBlue.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      LineSeries<TransactionData, String>(
                        dataSource: _transactionData,
                        xValueMapper: (TransactionData data, _) => data.day,
                        yValueMapper: (TransactionData data, _) => data.amount,
                        color: ConstantString.lightBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SfCircularChart(
                    series: <CircularSeries<AccountData, String>>[
                      DoughnutSeries<AccountData, String>(
                        dataSource: _accountData,
                        xValueMapper: (AccountData data, _) => data.type,
                        yValueMapper: (AccountData data, _) => data.percentage,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionData {
  final String day;
  final double amount;

  TransactionData(this.day, this.amount);
}

class AccountData {
  final String type;
  final double percentage;

  AccountData(this.type, this.percentage);
}
