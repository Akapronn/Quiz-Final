import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ตัวติดตามค่าใช้จ่าย',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseTracker(),
    );
  }
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Map<String, dynamic>> _transactions = [];
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String _transactionType = 'รายได้';
  final _noteController = TextEditingController();

  void _addTransaction() {
    final amount = double.tryParse(_amountController.text);
    final date = _dateController.text;
    final note = _noteController.text;

    if (amount == null || date.isEmpty || note.isEmpty) {
      return; // การตรวจสอบข้อมูลที่ป้อน
    }

    setState(() {
      _transactions.add({
        'amount': amount,
        'date': date,
        'type': _transactionType,
        'note': note,
      });

      _amountController.clear();
      _dateController.clear();
      _noteController.clear();
    });
  }

  double get _totalIncome {
    return _transactions
        .where((tx) => tx['type'] == 'รายได้')
        .fold(0.0, (sum, tx) => sum + tx['amount']);
  }

  double get _totalExpense {
    return _transactions
        .where((tx) => tx['type'] == 'ค่าใช้จ่าย')
        .fold(0.0, (sum, tx) => sum + tx['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตัวติดตามค่าใช้จ่าย'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Input fields
            _buildInputField(_amountController, 'จำนวนเงิน', TextInputType.number),
            SizedBox(height: 10),
            _buildInputField(_dateController, 'วันที่ (เช่น 2024-09-27)'),
            SizedBox(height: 10),
            _buildTransactionTypeDropdown(),
            SizedBox(height: 10),
            _buildInputField(_noteController, 'หมายเหตุ'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTransaction,
              child: Text('เพิ่มรายการ', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 20),
            _buildSummary(),
            SizedBox(height: 20),
            Expanded(
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildTransactionTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _transactionType,
      onChanged: (String? newValue) {
        setState(() {
          _transactionType = newValue!;
        });
      },
      items: <String>['รายได้', 'ค่าใช้จ่าย']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 16)),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'ประเภทการทำรายการ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        Text(
          'รายได้รวม: ${_totalIncome.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text(
          'ค่าใช้จ่ายรวม: ${_totalExpense.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(
              '${_transactions[index]['type']}: ${_transactions[index]['amount']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${_transactions[index]['date']} - ${_transactions[index]['note']}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
