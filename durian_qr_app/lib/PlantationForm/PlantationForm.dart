import 'package:durian_qr_app/PlantationForm/PlantationService.dart';
import 'package:flutter/material.dart';

class PlantationForm extends StatefulWidget {
  final String qrCode;
  const PlantationForm({super.key, required this.qrCode});

  @override
  _PlantationFormState createState() => _PlantationFormState();
}

class _PlantationFormState extends State<PlantationForm> {
  final TextEditingController soilConditionController = TextEditingController();
  final TextEditingController weatherConditionController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();

  // Create an instance of FirebaseService
  final PlantationService firebaseService = PlantationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantation Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the scanned QR code result at the top
              Text(
                'Scanned QR Code: ${widget.qrCode}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Input fields
              _buildTextField('Soil Condition', soilConditionController),
              _buildTextField('Weather Condition', weatherConditionController),
              _buildTextField('Humidity Level (%)', humidityController),
              _buildTextField('Temperature (°C)', temperatureController),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Submit Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  /// Handles submission of the form data by sending it to Firebase.
  Future<void> _submitData() async {
    try {
      await firebaseService.postPlantationData(
        qrCode: widget.qrCode,
        soilCondition: soilConditionController.text,
        weatherCondition: weatherConditionController.text,
        humidity: humidityController.text,
        temperature: temperatureController.text,
      );
      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plantation data submitted!')),
      );
      // Dismiss the page after submission
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting data!')),
      );
    }
  }
}