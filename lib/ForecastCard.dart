import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String value;
  final String time;
  final IconData icon;

  const ForecastCard({
    super.key,
    required this.value,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      color: Colors.white24,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: 100,
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Icon(
                icon,
                size: 50,
              ),
              SizedBox(height: 8),
              Text(value)
            ],
          ),
        ),
      ),
    );
  }
}
