import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late bool isCompleted;

  @HiveField(3)
  late bool isMajorGoal;

  @HiveField(4)
  late bool isExtraCredit;

  // Custom read method to handle migration from old data format
  static Goal fromJson(Map<String, dynamic> json) {
    return Goal()
      ..text = json['text'] as String
      ..date = DateTime.parse(json['date'] as String)
      ..isCompleted = json['isCompleted'] as bool
      ..isMajorGoal = json['isMajorGoal'] as bool
      ..isExtraCredit = json['isExtraCredit'] as bool? ?? false;
  }
}

 