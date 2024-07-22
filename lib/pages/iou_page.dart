import 'package:flutter/material.dart';

class IOUPage extends StatefulWidget {
  const IOUPage({super.key});

  @override
  State<IOUPage> createState() => _IOUPageState();
}

class _IOUPageState extends State<IOUPage> {
  List<Map<String, String>> items = [];
  double total = 1200.0;
  double remaining = 0.0;

  void _addItem(Map<String, String> item) {
    setState(() {
      items.add(item);
      // Update the total and remaining as needed
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      // Update the total and remaining as needed
    });
  }

  void _openForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name*',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description*',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount*',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Start date*',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Collect the data and add to the list
                    _addItem({
                      'name': 'Sample Name', // Replace with actual data
                      'description':
                          'Sample Description', // Replace with actual data
                      'amount': '123.45', // Replace with actual data
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Background color
                  ),
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'JPY ${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
                Text(
                  'JPY ${remaining.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 8.0, // Set elevation to increase shadow
                    shadowColor:
                        Colors.black.withOpacity(0.5), // Darker shadow color
                    child: ListTile(
                      title: Text(
                        items[index]['name']!,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        items[index]['description']!,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'JPY ${items[index]['amount']!}',
                            style: TextStyle(color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () => _deleteItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
