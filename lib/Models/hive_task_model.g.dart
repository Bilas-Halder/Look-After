// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      email: fields[0] as String,
      title: fields[2] as String,
      note: fields[3] as String,
      status: fields[4] as int,
      date: fields[5] as DateTime,
      startTime: fields[6] as String,
      endTime: fields[7] as String,
      remind: fields[9] as int,
      repeat: fields[10] as String,
      priority: fields[11] as int,
      category: fields[12] as String,
      color: fields[13] as int,
      time_stamp: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.startTime)
      ..writeByte(7)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.remind)
      ..writeByte(10)
      ..write(obj.repeat)
      ..writeByte(11)
      ..write(obj.priority)
      ..writeByte(12)
      ..write(obj.category)
      ..writeByte(13)
      ..write(obj.color)
      ..writeByte(14)
      ..write(obj.time_stamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskCategoryModelAdapter extends TypeAdapter<TaskCategoryModel> {
  @override
  final int typeId = 1;

  @override
  TaskCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskCategoryModel(
      title: fields[0] as String,
      color: fields[1] as int,
      icon: fields[2] as int,
      left: fields[3] as int,
      done: fields[4] as int,
      deleteAble: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskCategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.left)
      ..writeByte(4)
      ..write(obj.done)
      ..writeByte(5)
      ..write(obj.deleteAble);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userID: fields[5] as String,
      name: fields[0] as String,
      email: fields[1] as String,
      phone: fields[2] as String,
      imgURL: fields[3] as String,
      username: fields[4] as String,
      verified: fields[6] as bool,
      edited: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.imgURL)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.userID)
      ..writeByte(6)
      ..write(obj.verified)
      ..writeByte(7)
      ..write(obj.edited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
