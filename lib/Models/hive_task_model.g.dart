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
      color: fields[13] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.color);
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
