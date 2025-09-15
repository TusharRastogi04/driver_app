import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // Dummy completed orders
  final List<Map<String, dynamic>> orderHistory = const [
    {
      "orderId": "ORD12345",
      "restaurant": "Food Hub",
      "customer": "John Doe",
      "amount": 350.0,
      "status": "Delivered",
      "date": "2025-09-12 14:35"
    },
    {
      "orderId": "ORD67890",
      "restaurant": "Pizza Town",
      "customer": "Alice Smith",
      "amount": 499.0,
      "status": "Delivered",
      "date": "2025-09-11 19:10"
    },
    {
      "orderId": "ORD54321",
      "restaurant": "Burger King",
      "customer": "Michael Lee",
      "amount": 220.0,
      "status": "Cancelled",
      "date": "2025-09-10 12:45"
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      case "In Progress":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.receipt_long, color: Colors.blue),
              ),
              title: Text(
                "Order ID: ${order['orderId']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("From: ${order['restaurant']}"),
                  Text("To: ${order['customer']}"),
                  Text("Amount: ₹${order['amount']}"),
                  Text("Date: ${order['date']}"),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(
                      order['status'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _statusColor(order['status']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
