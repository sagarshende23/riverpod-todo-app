// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      title: fields[0] as String,
      isDone: fields[1] as bool,
      groupIndex: fields[2] as int,
      priority: fields[3] as Priority,
      createdAt: fields[4] as DateTime?,
      dueDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.groupIndex)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 2;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.high;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.low;
      default:
        return Priority.high;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.high:
        writer.writeByte(0);
        break;
      case Priority.medium:
        writer.writeByte(1);
        break;
      case Priority.low:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskGroupTypeAdapter extends TypeAdapter<TaskGroupType> {
  @override
  final int typeId = 1;

  @override
  TaskGroupType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskGroupType.today;
      case 1:
        return TaskGroupType.tomorrow;
      case 2:
        return TaskGroupType.important;
      default:
        return TaskGroupType.today;
    }
  }

  @override
  void write(BinaryWriter writer, TaskGroupType obj) {
    switch (obj) {
      case TaskGroupType.today:
        writer.writeByte(0);
        break;
      case TaskGroupType.tomorrow:
        writer.writeByte(1);
        break;
      case TaskGroupType.important:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskGroupTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
