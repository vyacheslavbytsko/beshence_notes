// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_v1.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteV1Adapter extends TypeAdapter<NoteV1> {
  @override
  final typeId = 0;

  @override
  NoteV1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteV1(
      id: fields[0] as String,
      accountId: fields[1] as String,
      createdAt: fields[2] as DateTime,
      title: fields[3] as String,
      titleModifiedAt: fields[4] as DateTime?,
      text: fields[5] as String,
      textModifiedAt: fields[6] as DateTime?,
      deleted: fields[7] as bool,
      deletionStateChangedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteV1 obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.accountId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.titleModifiedAt)
      ..writeByte(5)
      ..write(obj.text)
      ..writeByte(6)
      ..write(obj.textModifiedAt)
      ..writeByte(7)
      ..write(obj.deleted)
      ..writeByte(8)
      ..write(obj.deletionStateChangedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteV1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
