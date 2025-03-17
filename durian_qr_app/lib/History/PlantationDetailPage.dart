import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlantationDetailPage extends StatelessWidget {
  final String qrCode;
  const PlantationDetailPage({super.key, required this.qrCode});

  @override
  Widget build(BuildContext context) {
    // Reference to the "records" subcollection for the given QR code.
    CollectionReference recordsRef = FirebaseFirestore.instance
        .collection('durian')
        .doc(qrCode)
        .collection('records');

    return Scaffold(
      appBar: AppBar(title: Text('Records for $qrCode')),
      body: StreamBuilder<QuerySnapshot>(
        stream: recordsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data!.docs;
          if (records.isEmpty) {
            return const Center(child: Text('No records found'));
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              var data = records[index].data() as Map<String, dynamic>;
              String soilCondition = data['soilCondition'] ?? 'Unknown';
              String weatherCondition = data['weatherCondition'] ?? 'Unknown';
              String humidity = data['humidity'] ?? 'Unknown';
              String temperature = data['temperature'] ?? 'Unknown';
              DateTime dateTime = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text('Record ${index + 1}'),
                  subtitle: Text(
                    'Soil: $soilCondition, Weather: $weatherCondition\n'
                        'Humidity: $humidity, Temperature: $temperature\n'
                        'Date: ${dateTime.toLocal()}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
