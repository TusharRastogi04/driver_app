import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../services/geofence_service.dart';
import 'order_history_screen.dart';

class AssignedOrderScreen extends StatefulWidget {
  const AssignedOrderScreen({super.key});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  String orderStatus = "Start Trip";
  String distanceInfo = "";
  double driverLat = 0, driverLng = 0;
  bool demoMode = true;

  // Dummy order details
  final String orderId = "ORD12345";
  final String restaurantName = "Food Hub";
  final double restaurantLat = 28.6139;
  final double restaurantLng = 77.2090;
  final String customerName = "John Doe";
  final double customerLat = 28.7041;
  final double customerLng = 77.1025;
  final double orderAmount = 350.0;

  final LocationService locationService = LocationService();
  final GeofenceService geofenceService = GeofenceService();

  @override
  void initState() {
    super.initState();
    locationService.startTracking((lat, lng) {
      setState(() {
        driverLat = lat;
        driverLng = lng;
      });
    });
  }

  @override
  void dispose() {
    locationService.stopTracking();
    super.dispose();
  }

  void _navigateTo(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
    try {
      if (!await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error launching Maps: $e")),
      );
    }
  }

  void _updateStatus() {
    switch (orderStatus) {
      case "Start Trip":
        setState(() => orderStatus = "Arrived at Restaurant");
        break;
      case "Arrived at Restaurant":
        setState(() => orderStatus = "Picked Up");
        break;
      case "Picked Up":
        setState(() => orderStatus = "Arrived at Customer");
        break;
      case "Arrived at Customer":
        setState(() => orderStatus = "Delivered");
        break;
      case "Delivered":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Delivered! 🎉")),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
          );
        });
        break;
    }
  }

  Widget _statusChip(String text, bool active) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: active ? Colors.green : Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Assigned Order"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID: $orderId",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.restaurant, color: Colors.orange),
                      title: Text(restaurantName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Lat: $restaurantLat, Lng: $restaurantLng"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Lat: $customerLat, Lng: $customerLng"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.currency_rupee,
                          color: Colors.green),
                      title: Text("₹$orderAmount",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Status Progress
            Text("Order Progress",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _statusChip("Trip Started", orderStatus != "Start Trip"),
                _statusChip(
                    "At Restaurant",
                    orderStatus == "Arrived at Restaurant" ||
                        orderStatus == "Picked Up" ||
                        orderStatus == "Arrived at Customer" ||
                        orderStatus == "Delivered"),
                _statusChip(
                    "Picked Up",
                    orderStatus == "Picked Up" ||
                        orderStatus == "Arrived at Customer" ||
                        orderStatus == "Delivered"),
                _statusChip(
                    "At Customer",
                    orderStatus == "Arrived at Customer" ||
                        orderStatus == "Delivered"),
                _statusChip("Delivered", orderStatus == "Delivered"),
              ],
            ),
            const SizedBox(height: 20),

            // Driver Info
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: Text("Driver Location"),
                subtitle: Text("Lat: $driverLat, Lng: $driverLng"),
                trailing: Text(distanceInfo,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _updateStatus,
                    icon: const Icon(Icons.check_circle),
                    label: Text(orderStatus),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (orderStatus.contains("Restaurant")) {
                        _navigateTo(restaurantLat, restaurantLng);
                      } else if (orderStatus.contains("Customer")) {
                        _navigateTo(customerLat, customerLng);
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Navigate"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
