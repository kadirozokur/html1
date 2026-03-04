import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String colorHex;

  @HiveField(3)
  final int iconCode;

  CategoryModel({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.iconCode,
  });
}

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      colorHex: fields[2] as String,
      iconCode: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.iconCode);
  }
}

