import 'package:hive_ce/hive.dart';
import '../../../domain/entities/library_item_entity.dart';

part 'library_hive_model.g.dart';

/// نموذج Hive للتخزين المحلي لعناصر المكتبة
@HiveType(typeId: 12)
class LibraryHiveModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final DateTime orderDate;
  
  @HiveField(4)
  final String typeString;
  
  @HiveField(5)
  final double price;
  
  @HiveField(6)
  final String? thumbnailUrl;
  
  @HiveField(7)
  final String? fileUrl;
  
  @HiveField(8)
  final bool isDelivered;

  LibraryHiveModel({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.typeString,
    required this.price,
    this.thumbnailUrl,
    this.fileUrl,
    required this.isDelivered,
  });

  // تحويل من نموذج عنصر المكتبة إلى نموذج Hive
  factory LibraryHiveModel.fromLibraryItemEntity(LibraryItemEntity entity) {
    String typeToString(LibraryItemType type) {
      switch (type) {
        case LibraryItemType.pdf: return 'pdf';
        case LibraryItemType.word: return 'word';
        case LibraryItemType.video: return 'video';
        case LibraryItemType.audio: return 'audio';
        case LibraryItemType.image: return 'image';
        case LibraryItemType.other: return 'other';
      }
    }

    return LibraryHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      orderDate: entity.orderDate,
      typeString: typeToString(entity.type),
      price: entity.price,
      thumbnailUrl: entity.thumbnailUrl,
      fileUrl: entity.fileUrl,
      isDelivered: entity.isDelivered,
    );
  }

  // تحويل من نموذج Hive إلى نموذج الكيان
  LibraryItemEntity toLibraryItemEntity() {
    LibraryItemType stringToType(String typeString) {
      switch (typeString.toLowerCase()) {
        case 'pdf': return LibraryItemType.pdf;
        case 'word':
        case 'ورقي': return LibraryItemType.word;
        case 'video':
        case 'فيديو': return LibraryItemType.video;
        case 'audio':
        case 'صوتي': return LibraryItemType.audio;
        case 'image':
        case 'صورة': return LibraryItemType.image;
        default: return LibraryItemType.other;
      }
    }

    return LibraryItemEntity(
      id: id,
      title: title,
      description: description,
      orderDate: orderDate,
      type: stringToType(typeString),
      price: price,
      thumbnailUrl: thumbnailUrl,
      fileUrl: fileUrl,
      isDelivered: isDelivered,
    );
  }
}