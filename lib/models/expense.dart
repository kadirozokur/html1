import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final String? categoryId;

  @HiveField(6)
  final bool? isRecurring;

  @HiveField(7)
  final String? recurrenceType;

  @HiveField(8)
  final String? title;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    this.categoryId,
    this.isRecurring,
    this.recurrenceType,
    this.title,
  });
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      amount: fields[1] as double,
      category: fields[2] as String,
      date: fields[3] as DateTime,
      note: fields[4] as String?,
      categoryId: fields[5] as String?,
      isRecurring: (fields[6] as bool?) ?? false,
      recurrenceType: fields[7] as String?,
      title: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.isRecurring)
      ..writeByte(7)
      ..write(obj.recurrenceType)
      ..writeByte(8)
      ..write(obj.title);
  }
}

