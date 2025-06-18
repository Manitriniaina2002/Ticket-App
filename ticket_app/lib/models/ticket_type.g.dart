// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketTypeAdapter extends TypeAdapter<TicketType> {
  @override
  final int typeId = 1;

  @override
  TicketType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketType(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      availableQuantity: fields[3] as int,
      soldQuantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TicketType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.availableQuantity)
      ..writeByte(4)
      ..write(obj.soldQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
