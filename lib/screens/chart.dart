import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile_project/models/measurement.dart';
import 'package:mobile_project/sqlite/daos/measurement_dao.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  double chartMax = 120;
  Map<String, List<Measurement>> bodyParts = {
    "Weight": [],
    "Chest": [],
    "Right Biceps": [],
    "Right Forearm": [],
    "Hips": [],
    "Right Thigh": [],
    "Right Calf": [],
    "Neck": [],
    "Shoulders": [],
    "Left Biceps": [],
    "Left Forearm": [],
    "Waist": [],
    "Left Thigh": [],
    "Left Calf": [],
  };

  @override
  void initState() {
    bodyParts.forEach((key, _) async {
      List<Measurement> history = await partHistory(key);
      setState(() {
        bodyParts.update(key, (value) => history);
      });
    });
    super.initState();
  }

  Future<List<Measurement>> partHistory(String part) async {
    List<Measurement> history =
        await MeasurementDAO().readMeasurementsFromPart(part);
    return history;
  }

  ChartSeries buildSeries(String name, List<Measurement> data) {
    return StackedLineSeries<Measurement, dynamic>(
      name: name,
      groupName: name,
      markerSettings: const MarkerSettings(isVisible: true),
      dataSource: data,
      xValueMapper: (Measurement m, _) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(m.updatedAt);
        return "${months[date.month - 1]} ${date.day}, ${date.year}";
      },
      yValueMapper: (Measurement m, _) {
        if (m.value > chartMax) {
          setState(() {
            chartMax = m.value;
          });
        }
        return m.value;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 15),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(
        labelRotation: 0,
      ),
      primaryYAxis: NumericAxis(
        maximum: chartMax,
      ),
      series:
          bodyParts.entries.map((e) => buildSeries(e.key, e.value)).toList(),
      trackballBehavior: TrackballBehavior(
          enable: true, activationMode: ActivationMode.singleTap),
    );
  }
}
