import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/transaction_model.dart';
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'expense';
  final List<String> _expenseCategories = [
    'Food', 'Transport', 'Housing', 'Bills', 'Entertainment', 'Shopping', 'Health', 'Other'
  ];
  final List<String> _incomeCategories = [
    'Salary', 'Freelance', 'Investment', 'Gifts', 'Other'
  ];
  final Map<String, String> _categoryImagePaths = {
    // Expenses
    'Food': 'assets/food.png', // EXAMPLE - REPLACE WITH YOUR PATHS
    'Transport': 'assets/transport.png',
    'Housing': 'assets/housing.png',
    'Bills': 'assets/bills.png',
    'Entertainment': 'assets/entertainment.png',
    'Shopping': 'assets/shopping.png',
    'Health': 'assets/health.png',
    // Income
    'Salary': 'assets/salary.png',
    'Freelance': 'assets/freelance.png',
    'Investment': 'assets/investment.png',
    'Gifts': 'assets/images/gifts.png',
    // Default/Other
    'Other': 'assets/images/other_transaction.png', // A general fallback image
  };
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Adjust as needed
      lastDate: DateTime(2101),  // Adjust as needed
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _titleController.text;
      final enteredAmount = double.tryParse(_amountController.text);

      if (_selectedCategory == null || enteredAmount == null || enteredAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all fields correctly, including selecting a category and a valid amount.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final imagePathForTransaction =
          _categoryImagePaths[_selectedCategory!] ?? _categoryImagePaths['Other'] ?? 'assets/images/default_transaction.png'; // Ensure a fallback

      final newTransaction = Transaction(
        title: enteredTitle,
        amount: enteredAmount,
        category: _selectedCategory!,
        date: _selectedDate,
        type: _transactionType,
        imagePath: imagePathForTransaction,
      );

      Navigator.of(context).pop(newTransaction); // Send data back to Home screen
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final List<String> currentCategories = _transactionType == 'expense'
        ? _expenseCategories
        : _incomeCategories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Transaction'),
        backgroundColor: Color(0xff6a57ff),
        elevation: 1,
      ),
      body: Container( // Your outer container with background color and border radius
        // height: screenHeight, // Not needed if child is scrollable
        // width: screenWidth,   // Not needed if child is scrollable
          decoration: BoxDecoration(
            color: Color(0xffe1effc), // Your desired background
            // borderRadius: BorderRadius.circular(20), // This might be better on an inner container if AppBar is separate
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: ListView( // Using ListView to make the form scrollable
                    children: <Widget>[
                // --- ADD YOUR UI ELEMENTS HERE ---

                // 1. Transaction Type Toggle (Income/Expense)
                SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'expense', label: Text('Expense'), icon: Icon(Icons.arrow_downward)),
                ButtonSegment<String>(value: 'income', label: Text('Income'), icon: Icon(Icons.arrow_upward)),
                ],
            selected: <String>{_transactionType},
                onSelectionChanged: (Set<String> newSelection) {
          setState(() {
          _transactionType = newSelection.first;
          _selectedCategory = null; // Reset category when type changes
          });
          },
            style: SegmentedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, // Adapts to theme
              selectedBackgroundColor: _transactionType == 'expense'
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              selectedForegroundColor: _transactionType == 'expense' ? Colors.redAccent : Colors.green,
            ),
          ),
          SizedBox(height: 20),

          // 2. Title Field
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 15),

          // 3. Amount Field
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.parse(value) <= 0) {
                return 'Amount must be greater than zero';
              }
              return null;
            },
          ),
          SizedBox(height: 15),

          // 4. Category Dropdown
          DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.category),
              ),
              value: _selectedCategory,
              hint: Text('Select a category'),
              isExpanded: true,
              items: currentCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select a category' : null,
          ),
        SizedBox(height: 15),

        // 5. Date Picker
        Card( // Wrap in a card for better visual separation
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                  label: Text(
                    'Select Date',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () => _pickDate(context),
                ),
              ],
            ),
          ),
        ),
                      SizedBox(height: 30),

                      // 6. Save Button
                      ElevatedButton.icon(
                        icon: Icon(Icons.save_alt_outlined),
                        label: Text('Save Transaction'),
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6a57ff), // Your app's theme color
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 20), // Some padding at the bottom
                    ],
                ),
            ),
          ),
      ),
    );
  }
}
