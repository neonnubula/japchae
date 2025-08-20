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

// Custom adapter to handle migration
class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 0;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    
    return Goal()
      ..text = fields[0] as String
      ..date = fields[1] as DateTime
      ..isCompleted = fields[2] as bool
      ..isMajorGoal = fields[3] as bool
      ..isExtraCredit = fields[4] as bool? ?? false; // Handle missing field gracefully
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.isMajorGoal)
      ..writeByte(4)
      ..write(obj.isExtraCredit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 