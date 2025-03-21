import 'package:equatable/equatable.dart';

enum LibraryItemType { pdf, word, video, audio, image, other }

class LibraryItemEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? author; // إضافة خاصية المؤلف
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
    this.author, // إضافة خاصية المؤلف كمعلمة اختيارية
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
    author, // إضافة المؤلف إلى props
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

  // دالة مساعدة للتحقق مما إذا كان العنصر يطابق كلمة البحث
  bool matchesSearchQuery(String query) {
    query = query.toLowerCase();
    return title.toLowerCase().contains(query) ||
        (description?.toLowerCase().contains(query) ?? false) ||
        (author?.toLowerCase().contains(query) ?? false);
  }

  // دالة نسخ لإنشاء نسخة جديدة مع تغيير بعض الخصائص
  LibraryItemEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    DateTime? orderDate,
    LibraryItemType? type,
    double? price,
    String? thumbnailUrl,
    String? fileUrl,
    bool? isDelivered,
  }) {
    return LibraryItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      orderDate: orderDate ?? this.orderDate,
      type: type ?? this.type,
      price: price ?? this.price,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }
}
