import 'graph.dart';

class BarData {
  final double sunTask;
  final double monTask;
  final double tueTask;
  final double wedTask;
  final double thurTask;
  final double friTask;
  final double satTask;

  BarData({
    required this.sunTask,
    required this.monTask,
    required this.tueTask,
    required this.wedTask,
    required this.thurTask,
    required this.friTask,
    required this.satTask,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: 2),
      IndividualBar(x: 1, y: monTask),
      IndividualBar(x: 2, y: tueTask),
      IndividualBar(x: 3, y: wedTask),
      IndividualBar(x: 4, y: thurTask),
      IndividualBar(x: 5, y: friTask),
      IndividualBar(x: 6, y: satTask),
    ];
  }
}
