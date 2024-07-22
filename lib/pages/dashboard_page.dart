import 'package:flutter/material.dart';
import 'iou_page.dart';
import 'uome_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IOU', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
              color: Colors.white), // Set hamburger icon color to white
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
              fontSize: 16, // Set desired font size for selected tab
              fontWeight:
                  FontWeight.bold, // Set desired font weight for selected tab
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14, // Set desired font size for unselected tabs
              fontWeight: FontWeight
                  .normal, // Set desired font weight for unselected tabs
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            DashboardContent(),
            UOMePage(),
            IOUPage(),
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
                leading: Icon(Icons.person, color: Colors.black),
                title: Text('Profile'),
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
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard Content',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
