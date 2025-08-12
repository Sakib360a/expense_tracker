import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class txn_list_card extends StatelessWidget {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String type; // 'income' or 'expense'
  final String imagePath;
  const txn_list_card({
    super.key,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type, required this.screenHeight, required this.screenWidth, required this.imagePath,
    // required this.color,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final Color amountColor = type == 'income' ? Color(0xff00ba00) : Color(0xffef314c);
    final String amountPrefix = type == 'income' ? '+' : '-';
    final String formattedTime = DateFormat('hh:mm a').format(date);
    final String formattedDate = DateFormat('dd-MMM-yyyy').format(date);
    return Card(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          //margin: EdgeInsets.symmetric(horizontal: 5),
          height: screenHeight * .110,
          width: screenWidth * .99,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Image.asset(imagePath, scale: 14,errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error_outline, color: Colors.red, size: 22); // Fallback icon
              },),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        amountPrefix,
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        amount.toStringAsFixed(1),
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'TK',
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 2),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
