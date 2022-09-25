import 'package:flutter/material.dart';
import 'package:mobile_project/models/measurement.dart';

class InsertMeasurement extends StatelessWidget {
  InsertMeasurement({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _measurementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String bodyPart = ModalRoute.of(context)!.settings.name!;
    String suffixText = "cm";
    if (bodyPart == "Weight") {
      suffixText = "kg";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(bodyPart),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(suffix: Text(suffixText)),
                  controller: _measurementController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insert the measurement';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Measurement measurement = Measurement(
                            null,
                            bodyPart,
                            double.parse(_measurementController.text),
                            DateTime.now().millisecondsSinceEpoch);
                        Navigator.pop(context, measurement);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
