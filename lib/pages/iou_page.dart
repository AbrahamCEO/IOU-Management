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
                TextField(decoration: InputDecoration(labelText: 'Name*')),
                TextField(
                    decoration: InputDecoration(labelText: 'Contact Number')),
                TextField(decoration: InputDecoration(labelText: 'Email')),
                TextField(
                    decoration: InputDecoration(labelText: 'Description*')),
                TextField(decoration: InputDecoration(labelText: 'Amount*')),
                TextField(
                    decoration: InputDecoration(labelText: 'Start date*')),
                TextField(decoration: InputDecoration(labelText: 'Notes')),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18)),
                Text('JPY ${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Remaining', style: TextStyle(fontSize: 12)),
                Text('JPY ${remaining.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(items[index]['name']!),
                      subtitle: Text(items[index]['description']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('JPY ${items[index]['amount']!}'),
                          IconButton(
                            icon: Icon(Icons.delete),
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
        child: Icon(Icons.add),
      ),
    );
  }
}
