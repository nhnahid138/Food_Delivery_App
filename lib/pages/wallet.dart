import 'package:flutter/material.dart';

class wallet extends StatelessWidget {
  const wallet({super.key});

  @override
  Widget build(BuildContext context) {
    final indigo = Colors.indigo[900]!;

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
        child: Column(
          children: [
            /// Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: indigo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '0.00 TK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.add, 'Add'),
                _actionButton(Icons.send, 'Send'),
                _actionButton(Icons.history, 'History'),
              ],
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _transactionItem('Recharge', '0.00 TK'),
            _transactionItem('Cashback', '0.00 TK'),
            _transactionItem('Food', '0.00 TK'),
            _transactionItem('Delivery', '0.00 TK'),
          ],
        ),
      ),
    );
  }

  /// Simple Action Button
  static Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.indigo[900],
          radius: 24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Simple Transaction Row
  static Widget _transactionItem(String title, String amount) {
    final isDebit = amount.startsWith('-');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isDebit ? Colors.red : Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
