import 'package:durian_qr_app/History/PlantationDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPlantationPage extends StatelessWidget {
  const HistoryPlantationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Query all documents in the "durian" collection.
    CollectionReference durianRef = FirebaseFirestore.instance.collection('durian');

    return Scaffold(
      appBar: AppBar(title: const Text('History Plantation')),
      body: StreamBuilder<QuerySnapshot>(
        stream: durianRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No plantation found'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Use the document ID as the QR code.
              String qrCode = docs[index].id;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text('QR Code: $qrCode'),
                  onTap: () {
                    // Navigate to detail page to show records for this QR code.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantationDetailPage(qrCode: qrCode),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
