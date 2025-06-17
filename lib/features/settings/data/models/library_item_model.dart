import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/library_item_entity.dart';

part 'library_item_model.g.dart';

@JsonSerializable()
class LibraryItemModel extends LibraryItemEntity {
  @override
  @JsonKey(name: 'id')
  final String id;
  
  @override
  @JsonKey(name: 'title')
  final String title;
  
  @override
  @JsonKey(name: 'description')
  final String? description;
  
  @override
  @JsonKey(name: 'orderDate')
  final DateTime orderDate;
  
  @JsonKey(name: 'type')
  final String typeString;
  
  @override
  @JsonKey(name: 'price')
  final double price;
  
  @override
  @JsonKey(name: 'thumbnailUrl')
  final String? thumbnailUrl;
  
  @override
  @JsonKey(name: 'fileUrl')
  final String? fileUrl;
  
  @override
  @JsonKey(name: 'isDelivered')
  final bool isDelivered;

  LibraryItemModel({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.typeString,
    required this.price,
    this.thumbnailUrl,
    this.fileUrl,
    required this.isDelivered,
  }) : super(
          id: id,
          title: title,
          description: description,
          orderDate: orderDate,
          type: _mapStringToType(typeString),
          price: price,
          thumbnailUrl: thumbnailUrl,
          fileUrl: fileUrl,
          isDelivered: isDelivered,
        );

  factory LibraryItemModel.fromJson(Map<String, dynamic> json) =>
      _$LibraryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryItemModelToJson(this);

  factory LibraryItemModel.fromEntity(LibraryItemEntity entity) {
    return LibraryItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      orderDate: entity.orderDate,
      typeString: _mapTypeToString(entity.type),
      price: entity.price,
      thumbnailUrl: entity.thumbnailUrl,
      fileUrl: entity.fileUrl,
      isDelivered: entity.isDelivered,
    );
  }

  LibraryItemEntity toEntity() {
    return LibraryItemEntity(
      id: id,
      title: title,
      description: description,
      orderDate: orderDate,
      type: _mapStringToType(typeString),
      price: price,
      thumbnailUrl: thumbnailUrl,
      fileUrl: fileUrl,
      isDelivered: isDelivered,
    );
  }

  static LibraryItemType _mapStringToType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'pdf':
        return LibraryItemType.pdf;
      case 'word':
      case 'ورقي':
        return LibraryItemType.word;
      case 'video':
      case 'فيديو':
        return LibraryItemType.video;
      case 'audio':
      case 'صوتي':
        return LibraryItemType.audio;
      case 'image':
      case 'صورة':
        return LibraryItemType.image;
      default:
        return LibraryItemType.other;
    }
  }

  static String _mapTypeToString(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.pdf:
        return 'pdf';
      case LibraryItemType.word:
        return 'word';
      case LibraryItemType.video:
        return 'video';
      case LibraryItemType.audio:
        return 'audio';
      case LibraryItemType.image:
        return 'image';
      case LibraryItemType.other:
        return 'other';
    }
  }
}