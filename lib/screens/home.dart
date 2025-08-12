import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../widgets/in_ex_stat.dart';
import '../widgets/txn_list_card.dart';
import 'add_transaction_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _addNewTransaction(Transaction newTransaction) {
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  final List<Transaction> _transactions = [
    Transaction(
      title: 'Salary',
      amount: 2500.00,
      category: 'Income',
      date: DateTime(2023, 11, 5),
      type: 'income',
      imagePath: 'assets/salary.png',
    ),
    Transaction(
      title: 'Groceries',
      amount: 75.50,
      category: 'Food',
      date: DateTime(2023, 11, 10),
      type: 'expense',
      imagePath: 'assets/groceries.png',
    ),
    Transaction(
      title: 'Rent',
      amount: 800.00,
      category: 'Housing',
      date: DateTime(2023, 11, 1),
      type: 'expense',
      imagePath: 'assets/rent.png',
    ),
    Transaction(
      title: 'Freelance Project',
      amount: 300.00,
      category: 'Income',
      date: DateTime(2023, 11, 12),
      type: 'income',
      imagePath: 'assets/freelance.png',
    ),
    Transaction(
      title: 'Internet Bill',
      amount: 60.00,
      category: 'Bills',
      date: DateTime(2023, 11, 8),
      type: 'expense',
      imagePath: 'assets/internetbill.png',
    ),
    Transaction(
      title: 'Dinner Out',
      amount: 45.00,
      category: 'Food',
      date: DateTime(2023, 11, 15),
      type: 'expense',
      imagePath: 'assets/dinner.png',
    ),
    // Add more sample transactions
  ];
  void _deleteTransaction(Transaction transactionToRemove) {
    setState(() {
      _transactions.remove(transactionToRemove);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${transactionToRemove.title} deleted')),
      );
    });
  }
  double _calculateTotalIncome() {
    double totalIncome = 0;
    for (var transaction in _transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      }
    }
    return totalIncome;
  }

  double _calculateTotalExpense() {
    double totalExpense = 0;
    for (var transaction in _transactions) {
      if (transaction.type == 'expense') {
        totalExpense += transaction.amount;
      }
    }
    return totalExpense;
  }
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'en_BD', symbol: ''); // Adjust locale and symbol

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double currentTotalIncome = _calculateTotalIncome();
    final double currentTotalExpense = _calculateTotalExpense();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff6a57ff),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense\nTracker',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Color(0xffe1effc).withOpacity(.48),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTransactionScreen(),
                              ),
                            ).then((newTransaction) {
                              if (newTransaction != null &&
                                  newTransaction is Transaction) {
                                _addNewTransaction(newTransaction);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: 35,
                            color: Color(0xffe1effc),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 170,
            child: Container(
              width: screenWidth * .92,
              height: screenHeight * .79,
              decoration: BoxDecoration(
                color: Color(0xffe1effc),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InExStat(
                            text: 'Income',
                            amount: currencyFormatter.format(currentTotalIncome),
                            timeDuration: 'This month',
                            image: 'assets/IncomeArrow.png',
                            color: Color(0xff00ba00),
                          ),
                        ),
                        Expanded(
                          child: InExStat(
                            text: 'Expense',
                            amount: currencyFormatter.format(currentTotalExpense),
                            timeDuration: 'This month',
                            image: 'assets/ExpenseArrow.png',
                            color: Color(0xffef314c),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Recent transactions',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: ListView.builder(
                          itemCount: _transactions
                              .length, // Assuming you have a list of transaction data
                          itemBuilder: (context, index) {
                            final transaction =
                                _transactions[index]; // Get data for the current item
                            return Slidable(
                                key: ValueKey(transaction.title + transaction.date.toIso8601String()), // Unique key

                                // The end action pane is the one brought from the right
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(), // Or BehindMotion, ScrollMotion, DrawerMotion
                                  // motion: const DrawerMotion(), // Common motion for this
                                  dismissible: DismissiblePane(
                                    onDismissed: () {
                                      // This is called IF the SlidableAction is swiped far enough to dismiss
                                      _deleteTransaction(transaction);
                                    },
                                    // You can customize confirmDismiss here too
                                    // confirmDismiss: () async { ... return true/false ... },
                                  ),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        // This is called when the user TAPS the action button
                                        // For your UX, the main delete might happen via the DismissiblePane's onDismissed
                                        // Or, you can have tapping this also delete:
                                        _deleteTransaction(transaction);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      // borderRadius: BorderRadius.circular(12), // Optional styling
                                    ),
                                    // You can add more actions here if needed
                                    // SlidableAction(
                                    //   onPressed: (context) {/* Do something else */},
                                    //   backgroundColor: Colors.blue,
                                    //   foregroundColor: Colors.white,
                                    //   icon: Icons.archive,
                                    //   label: 'Archive',
                                    // ),
                                  ],),
                              child: txn_list_card(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                title: transaction.title,
                                amount: transaction.amount,
                                category: transaction.category,
                                date: transaction.date,
                                type: transaction.type,
                                imagePath: transaction.imagePath,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
