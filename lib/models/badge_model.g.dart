// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BadgeAdapter extends TypeAdapter<Badge> {
  @override
  final int typeId = 2;

  @override
  Badge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Badge(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      xpValue: fields[3] as int,
      category: fields[4] as BadgeCategory,
      rarity: fields[5] as BadgeRarity,
      requirement: fields[6] as int,
      maxEarnings: fields[7] as int,
      icon: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Badge obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.xpValue)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.rarity)
      ..writeByte(6)
      ..write(obj.requirement)
      ..writeByte(7)
      ..write(obj.maxEarnings)
      ..writeByte(8)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeProgressAdapter extends TypeAdapter<BadgeProgress> {
  @override
  final int typeId = 3;

  @override
  BadgeProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BadgeProgress(
      earned: fields[0] as bool,
      earnedDate: fields[1] as DateTime?,
      timesEarned: fields[2] as int,
      progress: fields[3] as int,
      maxEarnings: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.earned)
      ..writeByte(1)
      ..write(obj.earnedDate)
      ..writeByte(2)
      ..write(obj.timesEarned)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.maxEarnings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserLevelAdapter extends TypeAdapter<UserLevel> {
  @override
  final int typeId = 6;

  @override
  UserLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLevel(
      level: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      minXP: fields[3] as int,
      maxXP: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserLevel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.minXP)
      ..writeByte(4)
      ..write(obj.maxXP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GamificationDataAdapter extends TypeAdapter<GamificationData> {
  @override
  final int typeId = 7;

  @override
  GamificationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GamificationData(
      totalXP: fields[0] as int,
      currentLevel: fields[1] as int,
      badges: (fields[2] as Map?)?.cast<String, BadgeProgress>(),
      allTimeStats: (fields[3] as Map?)?.cast<String, int>(),
      lastUpdated: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GamificationData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalXP)
      ..writeByte(1)
      ..write(obj.currentLevel)
      ..writeByte(2)
      ..write(obj.badges)
      ..writeByte(3)
      ..write(obj.allTimeStats)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamificationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeCategoryAdapter extends TypeAdapter<BadgeCategory> {
  @override
  final int typeId = 4;

  @override
  BadgeCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeCategory.streak;
      case 1:
        return BadgeCategory.totalGoals;
      case 2:
        return BadgeCategory.special;
      default:
        return BadgeCategory.streak;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeCategory obj) {
    switch (obj) {
      case BadgeCategory.streak:
        writer.writeByte(0);
        break;
      case BadgeCategory.totalGoals:
        writer.writeByte(1);
        break;
      case BadgeCategory.special:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeRarityAdapter extends TypeAdapter<BadgeRarity> {
  @override
  final int typeId = 5;

  @override
  BadgeRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeRarity.common;
      case 1:
        return BadgeRarity.rare;
      case 2:
        return BadgeRarity.epic;
      case 3:
        return BadgeRarity.legendary;
      default:
        return BadgeRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeRarity obj) {
    switch (obj) {
      case BadgeRarity.common:
        writer.writeByte(0);
        break;
      case BadgeRarity.rare:
        writer.writeByte(1);
        break;
      case BadgeRarity.epic:
        writer.writeByte(2);
        break;
      case BadgeRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
