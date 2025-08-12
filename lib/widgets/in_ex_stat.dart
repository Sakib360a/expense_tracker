import 'package:flutter/material.dart';

class InExStat extends StatelessWidget {
  const InExStat({super.key, required this.text, required this.amount, required this.timeDuration, required this.image, required this.color});
  final String text;
  final String amount;
  final String timeDuration;
  final String image;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(image,scale: 14,),
        SizedBox(height: 2),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5),
              Text(
                'TK',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

        SizedBox(height: 2),
        Text(
          timeDuration,
          style: TextStyle(color: Color(0xff545157), fontSize: 18),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
