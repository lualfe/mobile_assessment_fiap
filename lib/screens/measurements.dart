import 'package:flutter/material.dart';
import 'package:mobile_project/models/measurement.dart';
import 'package:mobile_project/sqlite/daos/measurement_dao.dart';
import 'package:mobile_project/sqlite/insert_measurement.dart';

class Measurements extends StatefulWidget {
  const Measurements({super.key});

  @override
  State<Measurements> createState() => _MeasurementsState();
}

class _MeasurementsState extends State<Measurements> {
  Map<String, Measurement> measurements = {
    "Weight": Measurement(null, "Weight", 0, 0),
    "Chest": Measurement(null, "Chest", 0, 0),
    "Right Biceps": Measurement(null, "Right Biceps", 0, 0),
    "Right Forearm": Measurement(null, "Right Forearm", 0, 0),
    "Hips": Measurement(null, "Hips", 0, 0),
    "Right Thigh": Measurement(null, "Right Thigh", 0, 0),
    "Right Calf": Measurement(null, "Right Calf", 0, 0),
    "Neck": Measurement(null, "Neck", 0, 0),
    "Shoulders": Measurement(null, "Shoulders", 0, 0),
    "Left Biceps": Measurement(null, "Left Biceps", 0, 0),
    "Left Forearm": Measurement(null, "Left Forearm", 0, 0),
    "Waist": Measurement(null, "Waist", 0, 0),
    "Left Thigh": Measurement(null, "Left Thigh", 0, 0),
    "Left Calf": Measurement(null, "Left Calf", 0, 0),
  };

  @override
  void initState() {
    super.initState();
    currentMeasurements();
  }

  List<Measurement> rightColumn() {
    return [
      measurements["Weight"]!,
      measurements["Chest"]!,
      measurements["Right Biceps"]!,
      measurements["Right Forearm"]!,
      measurements["Hips"]!,
      measurements["Right Thigh"]!,
      measurements["Right Calf"]!,
    ];
  }

  List<Measurement> leftColumn() {
    return [
      measurements["Neck"]!,
      measurements["Shoulders"]!,
      measurements["Left Biceps"]!,
      measurements["Left Forearm"]!,
      measurements["Waist"]!,
      measurements["Left Thigh"]!,
      measurements["Left Calf"]!,
    ];
  }

  currentMeasurements() async {
    List<Measurement> current =
        await MeasurementDAO().readCurrentMeasurements();

    setState(() {
      for (var i = 0; i < current.length; i++) {
        measurements.update(current[i].bodyPart, (value) => current[i]);
      }
    });
  }

  insertMeasurement(Measurement? measurement) async {
    if (measurement == null) {
      return;
    }

    int id = await MeasurementDAO().insertMeasurement(measurement);
    if (id > 0) {
      setState(() {
        measurements.forEach((key, value) {
          if (value.bodyPart == measurement.bodyPart) {
            measurement.id = id;
            measurements[key] = measurement;
          }
        });
      });
    }
  }

  Widget getCardContainer(Measurement measurement) {
    String unit = "cm";
    if (measurement.bodyPart == "Weight") {
      unit = "kg";
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InsertMeasurement(),
                        settings: RouteSettings(name: measurement.bodyPart)))
                .then((measurement) => insertMeasurement(measurement))
          },
          child: SizedBox(
            width: 100,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(measurement.bodyPart),
                Text("${measurement.value} $unit"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getColumn(List<Measurement> measurements) {
    return SingleChildScrollView(
      child: Column(
        children: measurements
            .map((measurement) => getCardContainer(measurement))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Body.jpeg"),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, top: 50),
          child: Align(
            alignment: Alignment.topLeft,
            child: getColumn(leftColumn()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 5, top: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: getColumn(rightColumn()),
          ),
        ),
      ],
    );
  }
}
