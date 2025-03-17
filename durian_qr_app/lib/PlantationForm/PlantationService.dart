import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to handle Firebase operations.
class PlantationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Posts plantation data to the Firestore structure:
  /// durian/{qrCode}/records/{randomIdentifier}
  Future<void> postPlantationData({
    required String qrCode,
    required String soilCondition,
    required String weatherCondition,
    required String humidity,
    required String temperature,
  }) async {
    await _firestore
        .collection('durian')
        .doc(qrCode)
        .collection('records')
        .add({
      'qrCode': qrCode,
      'soilCondition': soilCondition,
      'weatherCondition': weatherCondition,
      'humidity': humidity,
      'temperature': temperature,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}