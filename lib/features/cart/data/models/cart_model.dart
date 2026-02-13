import 'package:hive_ce/hive.dart';

part 'cart_model.g.dart';
@HiveType(typeId: 112)
class CartItemModel extends HiveObject {
  @HiveField(0)
  String bookId;

  @HiveField(1)
  String bookName;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String type;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  double unitPrice;

  CartItemModel({
    required this.bookId,
    required this.bookName,
    required this.imageUrl,
    required this.type,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;
}
