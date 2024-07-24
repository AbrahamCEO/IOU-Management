import 'package:flutter/material.dart';
import 'package:iouapp/services/database_service.dart';

class IOUPage extends StatefulWidget {
  final Function updateData;

  const IOUPage({required this.updateData, super.key});

  @override
  State<IOUPage> createState() => _IOUPageState();
}

class _IOUPageState extends State<IOUPage> {
  final DatabaseService _dbService = DatabaseService.instance;
  List<Map<String, dynamic>> _items = [];
  double total = 0.00;
  double remaining = 0.00;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _dbService.getIOU();
    double newTotal = 0.00;

    for (var item in items) {
      newTotal += item['Amount'] ?? 0.00;
    }

    setState(() {
      _items = items;
      total = newTotal;
      remaining = total -
          (items
              .where((item) => item['Paid'] == 1)
              .fold(0.0, (prev, item) => prev + item['Amount']));
    });
  }

  void _deleteItem(int id) async {
    await _dbService.deleteIOU(id);
    _fetchItems();
    widget.updateData();
  }

  void _openForm({Map<String, dynamic>? item}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?['Name'] ?? '');
    final _contactNumberController =
        TextEditingController(text: item?['Contact_Number'] ?? '');
    final _emailController = TextEditingController(text: item?['Email'] ?? '');
    final _descriptionController =
        TextEditingController(text: item?['Description'] ?? '');
    final _amountController =
        TextEditingController(text: item?['Amount']?.toString() ?? '');
    final _startDateController =
        TextEditingController(text: item?['Start_Date'] ?? '');
    final _notesController = TextEditingController(text: item?['Notes'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name*'),
                    validator: (value) =>
                        value!.isEmpty ? 'Name is required' : null,
                  ),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description*'),
                    validator: (value) =>
                        value!.isEmpty ? 'Description is required' : null,
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount*'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Amount is required' : null,
                  ),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(labelText: 'Start Date*'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _startDateController.text =
                            pickedDate.toLocal().toString().split(' ')[0];
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Start Date is required' : null,
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(labelText: 'Notes'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (item == null) {
                          _dbService.addIOU({
                            'Name': _nameController.text,
                            'Contact_Number': _contactNumberController.text,
                            'Email': _emailController.text,
                            'Description': _descriptionController.text,
                            'Amount': double.parse(_amountController.text),
                            'Start_Date': _startDateController.text,
                            'End_Date': null,
                            'Notes': _notesController.text,
                            'Paid': 0,
                          }).then((_) {
                            Navigator.of(context).pop();
                            _fetchItems();
                            widget.updateData();
                          }).catchError((e) {
                            print("Error adding IOU: $e");
                          });
                        } else {
                          _dbService.updateIOU(item['id'], {
                            'Name': _nameController.text,
                            'Contact_Number': _contactNumberController.text,
                            'Email': _emailController.text,
                            'Description': _descriptionController.text,
                            'Amount': double.parse(_amountController.text),
                            'Start_Date': _startDateController.text,
                            'End_Date': item['End_Date'],
                            'Notes': _notesController.text,
                            'Paid': item['Paid'],
                          }).then((_) {
                            Navigator.of(context).pop();
                            _fetchItems();
                            widget.updateData();
                          }).catchError((e) {
                            print("Error updating IOU: $e");
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(item == null ? 'Save' : 'Update'),
                  ),
                ],
              ),
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'USD ${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
                    color: Color.fromARGB(255, 63, 63, 63),
                  ),
                ),
                Text(
                  'USD ${remaining.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 63, 62, 62),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 6,
                    child: ListTile(
                      onTap: () => _openForm(item: _items[index]),
                      title: Text(
                        _items[index]['Name']!,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _items[index]['Description']!,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 45, 44, 44)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'USD ${_items[index]['Amount']!}',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black),
                            onPressed: () => _deleteItem(_items[index]['id']),
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
        onPressed: () => _openForm(),
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
