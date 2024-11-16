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
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone)
      ..writeByte(2)
      ..write(obj.groupIndex)
      ..writeByte(3)
      ..write(obj.createdAt);
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
      case 3:
        return TaskGroupType.notImportant;
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
      case TaskGroupType.notImportant:
        writer.writeByte(3);
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
