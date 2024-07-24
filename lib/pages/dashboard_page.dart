import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iouapp/services/database_service.dart';
import 'iou_page.dart';
import 'uome_page.dart';

// Common styles
final kPrimaryColor = Color.fromARGB(255, 255, 157, 0);
final kSecondaryColor = Color.fromARGB(255, 0, 0, 0);
final kBackgroundColor = Color(0xFFF5F5F5);
final kTextColor = Color(0xFF333333);

final kHeadlineStyle = GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

final kBodyStyle = GoogleFonts.roboto(
  fontSize: 16,
  color: kTextColor,
);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  final DatabaseService _dbService = DatabaseService.instance;
  double _netBalance = 0.00;
  List<Map<String, dynamic>> _iouItems = [];
  List<Map<String, dynamic>> _uomeItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final iouItems = await _dbService.getIOU();
    final uomeItems = await _dbService.getUOMe();

    double iouTotal = 0.00;
    double uomeTotal = 0.00;

    for (var item in iouItems) {
      iouTotal += item['Amount'] ?? 0.00;
    }
    for (var item in uomeItems) {
      uomeTotal += item['Amount'] ?? 0.00;
    }

    setState(() {
      _iouItems = iouItems;
      _uomeItems = uomeItems;
      _netBalance = uomeTotal - iouTotal;
    });
  }

  void _updateData() {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IOU', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Dashboard'),
              Tab(text: 'UOMe'),
              Tab(text: 'IOU'),
            ],
            indicatorColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.orange,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DashboardContent(
                updateData: _updateData,
                iouItems: _iouItems,
                uomeItems: _uomeItems),
            UOMePage(updateData: _updateData),
            IOUPage(updateData: _updateData),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text('Menu', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text('Dashboard'),
              ),
              ListTile(
                leading: Icon(Icons.currency_exchange, color: Colors.black),
                title: Text('Currencies'),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final Function updateData;
  final List<Map<String, dynamic>> iouItems;
  final List<Map<String, dynamic>> uomeItems;

  const DashboardContent({
    required this.updateData,
    required this.iouItems,
    required this.uomeItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: kHeadlineStyle),
          SizedBox(height: 24),
          NetBalanceCard(iouItems: iouItems, uomeItems: uomeItems),
          SizedBox(height: 24),
          BalanceDistributionChart(iouItems: iouItems, uomeItems: uomeItems),
          SizedBox(height: 24),
          RecentTransactionsList(iouItems: iouItems, uomeItems: uomeItems),
        ],
      ),
    );
  }
}

class NetBalanceCard extends StatelessWidget {
  final List<Map<String, dynamic>> iouItems;
  final List<Map<String, dynamic>> uomeItems;

  const NetBalanceCard({
    required this.iouItems,
    required this.uomeItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double iouTotal = 0.00;
    double uomeTotal = 0.00;

    for (var item in iouItems) {
      iouTotal += item['Amount'] ?? 0.00;
    }
    for (var item in uomeItems) {
      uomeTotal += item['Amount'] ?? 0.00;
    }

    final netBalance = uomeTotal - iouTotal;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Net Balance', style: kBodyStyle),
            SizedBox(height: 8),
            Text(
              'USD ${netBalance.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceDistributionChart extends StatelessWidget {
  final List<Map<String, dynamic>> iouItems;
  final List<Map<String, dynamic>> uomeItems;

  const BalanceDistributionChart({
    required this.iouItems,
    required this.uomeItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double iouTotal = 0.00;
    double uomeTotal = 0.00;

    for (var item in iouItems) {
      iouTotal += item['Amount'] ?? 0.00;
    }
    for (var item in uomeItems) {
      uomeTotal += item['Amount'] ?? 0.00;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance Distribution', style: kBodyStyle),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: kPrimaryColor,
                      value: iouTotal,
                      title: 'IOU',
                      radius: 50,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    PieChartSectionData(
                      color: kSecondaryColor,
                      value: uomeTotal,
                      title: 'UOMe',
                      radius: 50,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
  final List<Map<String, dynamic>> iouItems;
  final List<Map<String, dynamic>> uomeItems;

  const RecentTransactionsList({
    required this.iouItems,
    required this.uomeItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Create a combined list of transactions with type included
    final transactions = <Map<String, dynamic>>[
      ...iouItems.map((item) => {
            ...item, // Copy existing fields
            'Type': 'IOU',
          }),
      ...uomeItems.map((item) => {
            ...item, // Copy existing fields
            'Type': 'UOMe',
          }),
    ];

    // Sort transactions by date if available
    transactions.sort((a, b) {
      DateTime dateA =
          DateTime.tryParse(a['Start_Date'] ?? '') ?? DateTime.now();
      DateTime dateB =
          DateTime.tryParse(b['Start_Date'] ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA); // Most recent first
    });

    // Determine height based on the number of transactions
    double itemHeight = 80; // Approximate height of each ListTile
    double baseHeight = 50; // Base height for the header
    double totalHeight = transactions.length * itemHeight + baseHeight;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Transactions',
                style: kBodyStyle.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: totalHeight, // Set dynamic height here
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final isIOU = transaction['Type'] == 'IOU';
                  final iconColor = isIOU ? Colors.red : Colors.green;
                  final text = isIOU ? 'IOU' : 'UOMe';
                  final amount = transaction['Amount'] ?? 0.00;
                  final description = transaction['Start_Date'] ?? 'No Date';
                  final date =
                      DateTime.tryParse(transaction['Start_Date'] ?? '') ??
                          DateTime.now();
                  final name = transaction['Name'] ?? 'Unnamed Transaction';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isIOU ? Icons.arrow_downward : Icons.arrow_upward,
                            color: iconColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            text,
                            style: TextStyle(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      title: Text(name, style: kBodyStyle),
                      subtitle: Text(description,
                          style: kBodyStyle.copyWith(fontSize: 14)),
                      trailing: Text('\$${amount.toStringAsFixed(2)}',
                          style:
                              kBodyStyle.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
