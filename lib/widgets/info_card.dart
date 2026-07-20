import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 35),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}