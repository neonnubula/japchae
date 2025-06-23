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
} 