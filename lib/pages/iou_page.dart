import 'package:flutter/material.dart';
import 'package:iouapp/services/database_service.dart';

class IOUPage extends StatefulWidget {
  final Function updateData;
npm install cypress --save-dev

  const IOUPage({required this.updateData, super.key});

  @override
  State<IOUPage> createState() => _IOUPageState();
}

class _IOUPageState extends State<IOUPage> {
  final DatabaseService _dbService = DatabaseService.instance;
  List<Map<String, dynamic>> _items = [];
  double total = 0.0;
  double remaining = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _dbService.getIOU();
    double newTotal = 0.0;

    for (var item in items) {
      newTotal += item['Amount'] ?? 0.0;
    }

    setState(() {
      _items = items;
      remaining = newTotal -
          items.fold(0.0, (prev, item) => prev + (item['Amount'] ?? 0.0));
      total = newTotal;
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
    String _status = item?['Status'] ?? 'Started';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Stack(
              children: [
                Form(
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
                        decoration:
                            InputDecoration(labelText: 'Contact Number'),
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
                            final newItem = {
                              'Name': _nameController.text,
                              'Contact_Number': _contactNumberController.text,
                              'Email': _emailController.text,
                              'Description': _descriptionController.text,
                              'Amount': double.parse(_amountController.text),
                              'Start_Date': _startDateController.text,
                              'End_Date': item?['End_Date'] ?? null,
                              'Notes': _notesController.text,
                              'Status': _status,
                              'Type': 'IOU',
                            };

                            if (item == null) {
                              _dbService.addIOU(newItem).then((_) {
                                Navigator.of(context).pop();
                                _fetchItems();
                                widget.updateData();
                              }).catchError((e) {
                                print("Error adding IOU: $e");
                              });
                            } else {
                              _dbService
                                  .updateIOU(item['id'], newItem)
                                  .then((_) {
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: getStatusColor(_status),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Started',
                          child: Text('Started'),
                        ),
                        PopupMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        PopupMenuItem(
                          value: 'Paid',
                          child: Text('Paid'),
                        ),
                        PopupMenuItem(
                          value: 'Overpaid',
                          child: Text('Overpaid'),
                        ),
                        PopupMenuItem(
                          value: 'Overdue',
                          child: Text('Overdue'),
                        ),
                        PopupMenuItem(
                          value: 'Forgiven',
                          child: Text('Forgiven'),
                        ),
                        PopupMenuItem(
                          value: 'Blacklist',
                          child: Text('Blacklist'),
                        ),
                      ],
                      child: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ),
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
                  final item = _items[index];
                  final amount = item['Amount']?.toDouble() ?? 0.0;
                  final status = item['Status'] ?? 'Started';

                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Icon(
                        Icons.attach_money,
                        color: getStatusColor(status),
                      ),
                      title: Text(item['Name'] ?? ''),
                      subtitle: Text(
                        'Amount: USD ${amount.toStringAsFixed(2)}\nStatus: $status',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item['id']),
                      ),
                      onTap: () => _openForm(item: item),
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
        child: Icon(Icons.add),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Started':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Paid':
        return Colors.blue;
      case 'Overpaid':
        return Colors.yellow;
      case 'Overdue':
        return Colors.red;
      case 'Forgiven':
        return Color.fromARGB(255, 121, 119, 119);
      case 'Blacklist':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}
