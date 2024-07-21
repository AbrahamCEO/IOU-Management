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
          title: const Text('IOU'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'UOMe'),
              Tab(text: 'IOU'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DashboardContent(),
            UOMePage(),
            IOUPage(),
          ],
        ),
        drawer: Drawer(),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dashboard Content'),
    );
  }
}
