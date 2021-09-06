import 'package:flutter/material.dart';
import 'package:interactive_workout_app/features/workout/data/models/fitness_update_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FitnessChart extends StatefulWidget {
  const FitnessChart({Key key}) : super(key: key);

  @override
  _FitnessChartState createState() => _FitnessChartState();
}

class _FitnessChartState extends State<FitnessChart> {
  @override
  Widget build(BuildContext context) {
    final recentFitnessData = Provider.of<List<FitnessUpdateModel>>(context);
    recentFitnessData.isEmpty
        ? print("recent fitness info from FitnessChart.dart is empty")
        : recentFitnessData.forEach((element) {
            print("FitnessChartData: " + element.dateTime.toString());
          });
    return recentFitnessData.isNotEmpty
        ? SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              minimum: DateTime.now().subtract(Duration(days: 7)),
              maximum: DateTime.now(),
              dateFormat: DateFormat.MMMd(),
            ),
            series: <LineSeries<FitnessData, DateTime>>[
              LineSeries<FitnessData, DateTime>(
                dataSource: recentFitnessData.map((update) {
                  if (update.dateTime
                      .isAfter(DateTime.now().subtract(Duration(days: 7)))) {
                    return FitnessData(update.dateTime, update.caloriesBurned);
                  }
                  return FitnessData(DateTime.now(), 0);
                }).toList(),
                xValueMapper: (FitnessData fitnessData, _) => fitnessData.date,
                // xValueMapper: (FitnessData fitnessData, _) =>
                //     DateFormat('MMMd').format(fitnessData.date),
                yValueMapper: (FitnessData fitnessData, _) =>
                    fitnessData.calories,
              ),
            ],
          )
        : CircularProgressIndicator();
  }
}

class FitnessData {
  final DateTime date;
  final double calories;

  FitnessData(this.date, this.calories);
}