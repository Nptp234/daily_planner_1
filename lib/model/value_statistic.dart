
import 'package:daily_planner_1/data/model/task.dart';

Map<String, double> _values = {
  "Created": 0,
  "In Process": 0,
  "Done": 0,
  "Ended": 0
};

void setValueList(List<Task> lst){
  _values.updateAll((key, value) => 0);
  for(var task in lst){
    String state = task.state!;
    switch (state) {
      case "Created":
        _values["Created"] = (_values["Created"] ?? 0) + 1;
        break;
      case "In Process":
        _values["In Process"] = (_values["In Process"] ?? 0) + 1;
        break;
      case "Done":
        _values["Done"] = (_values["Done"] ?? 0) + 1;
        break;
      case "Ended":
        _values["Ended"] = (_values["Ended"] ?? 0) + 1;
        break;
    }
  }
}

double calculatePercentage(String state) {
  double total = _values.values.reduce((a, b) => a + b);
  if (total == 0) return 0; 
  return ((_values[state] ?? 0) / total) * 100;
}