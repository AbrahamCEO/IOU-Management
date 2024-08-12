import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iouapp/services/database_service.dart';
import 'iou_page.dart';
import 'uome_page.dart';
ddddddddddddd
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
              uomeItems: _uomeItems,
            ),
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
    double iouTotal = 0.00;
    double uomeTotal = 0.00;

    for (var item in iouItems) {
      iouTotal += item['Amount'] ?? 0.00;
    }
    for (var item in uomeItems) {
      uomeTotal += item['Amount'] ?? 0.00;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: kHeadlineStyle,
          ),
          SizedBox(height: 10),
          NetBalanceCard(iouItems: iouItems, uomeItems: uomeItems),
          SizedBox(height: 10),
          BalanceDistributionChart(iouItems: iouItems, uomeItems: uomeItems),
          SizedBox(height: 24),
          IOUCard(totalAmount: iouTotal),
          SizedBox(height: 16),
          UOMeCard(totalAmount: uomeTotal),
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
            SizedBox(height: 3),
            Text(
              'USD ${netBalance.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 28,
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
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: kPrimaryColor,
                      value: iouTotal,
                      title: 'IOU',
                      radius: 40,
                      titleStyle: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    PieChartSectionData(
                      color: kSecondaryColor,
                      value: uomeTotal,
                      title: 'UOMe',
                      radius: 40,
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

class IOUCard extends StatelessWidget {
  final double totalAmount;

  const IOUCard({
    required this.totalAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 50,
              color: kPrimaryColor, // Orange color for IOU
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IOU',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\USD ${totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UOMeCard extends StatelessWidget {
  final double totalAmount;

  const UOMeCard({
    required this.totalAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 50,
              color: Colors.black, // Black color for UOMe
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UOMe',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\USD ${totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
