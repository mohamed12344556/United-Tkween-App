import 'package:equatable/equatable.dart';

enum LibraryItemType {
  pdf,
  word,
  video,
  audio,
  image,
  other,
}

class LibraryItemEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime orderDate;
  final LibraryItemType type;
  final double price;
  final String? thumbnailUrl;
  final String? fileUrl;
  final bool isDelivered;
  
  const LibraryItemEntity({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.type,
    required this.price,
    this.thumbnailUrl,
    this.fileUrl,
    required this.isDelivered,
  });
  
  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    orderDate, 
    type, 
    price, 
    thumbnailUrl, 
    fileUrl,
    isDelivered,
  ];
  
  String get formattedDate {
    return '${orderDate.day}-${orderDate.month}-${orderDate.year}';
  }
  
  String get typeAsString {
    switch (type) {
      case LibraryItemType.pdf:
        return 'PDF';
      case LibraryItemType.word:
        return 'ورقي';
      case LibraryItemType.video:
        return 'فيديو';
      case LibraryItemType.audio:
        return 'صوتي';
      case LibraryItemType.image:
        return 'صورة';
      case LibraryItemType.other:
        return 'أخرى';
    }
  }
  
  String get deliveryStatus {
    return isDelivered ? 'تم التوصيل' : 'في الطريق';
  }
}