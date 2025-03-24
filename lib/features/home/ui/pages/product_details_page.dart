import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/core/helper/format_double_number.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import '../../../cart/data/cart_model.dart';
import '../../data/book_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final BookModel book;

  const ProductDetailsPage({super.key, required this.book});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String selectedType;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    selectedType = (widget.book.getFormattedPdfPrice == 0) ? "paper" : "PDF";
    _checkGuestStatus();
  }

  // التحقق من حالة الضيف
  Future<void> _checkGuestStatus() async {
    final isGuest = await GuestModeManager.isGuestMode();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }

  int quantity = 1;
  String selectedCategory = "روايات";

  List<String> bookCategories = [
    "روايات",
    "تطوير الذات",
    "الكتب العلمية",
    "الكتب الدينية",
    "الكتب التقنية",
  ];
  List<String> bookTypes = ["PDF", "paper"];

  double getSelectedPrice() {
    if (selectedType == "PDF") {
      debugPrint(widget.book.getFormattedPdfPrice.toString());
      return widget.book.getFormattedPdfPrice;
    } else {
      return widget.book.getFormattedPrice;
    }
  }

  // إضافة المنتج إلى السلة مع التحقق من وضع الضيف
  Future<void> _addToCart() async {
    // التحقق مما إذا كان المستخدم في وضع الضيف
    if (_isGuest) {
      if (mounted) {
        // عرض مربع حوار القيود إذا كان في وضع الضيف
        await context.checkGuestRestriction(featureName: "إضافة للسلة");
      }
      return;
    }

    // الكود الأصلي لإضافة المنتج إلى السلة للمستخدمين المسجلين
    if (getSelectedPrice() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "عذرًا، لا يوجد سعر متاح لهذا النوع من الكتاب. يرجى اختيار نوع مختلف.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final cartBox = Hive.box<CartItemModel>('CartBox');

      final cartItems = cartBox.values.toList();

      final existingItem = cartItems.firstWhereOrNull(
        (item) => item.bookId == widget.book.id && item.type == selectedType,
      );

      if (existingItem != null) {
        existingItem.quantity += quantity;
        await existingItem.save();
      } else {
        final newItem = CartItemModel(
          bookId: widget.book.id,
          bookName: widget.book.title,
          imageUrl: widget.book.imageUrl,
          type: selectedType,
          quantity: quantity,
          unitPrice: getSelectedPrice(),
        );
        await cartBox.add(newItem);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت الإضافة إلى السلة!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  // إضافة المنتج إلى المفضلة مع التحقق من وضع الضيف
  Future<void> _addToFavorites() async {
    // التحقق مما إذا كان المستخدم في وضع الضيف
    if (_isGuest) {
      if (mounted) {
        // عرض مربع حوار القيود إذا كان في وضع الضيف
        await context.checkGuestRestriction(featureName: "إضافة للمفضلة");
      }
      return;
    }

    // إضافة للمفضلة
    final favoritesBox = Hive.box<BookModel>('favorites');

    // التحقق إذا كان الكتاب موجود بالفعل في المفضلة
    if (favoritesBox.containsKey(widget.book.id)) {
      favoritesBox.delete(widget.book.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إزالة الكتاب من المفضلة'),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      // إضافة الكتاب إلى المفضلة
      favoritesBox.put(widget.book.id, widget.book);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إضافة الكتاب إلى المفضلة'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = getSelectedPrice() * quantity;
    final favoritesBox = Hive.box<BookModel>('favorites');
    final isFavorite = favoritesBox.containsKey(widget.book.id);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Hero(
            tag: widget.book.id,
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.book.imageUrl.asFullImageUrl ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .5,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.book.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // إضافة زر المفضلة مع التحقق من وضع الضيف
                        GestureDetector(
                          onTap: _addToFavorites,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  _isGuest
                                      ? Colors
                                          .grey // تغيير لون أيقونة المفضلة في وضع الضيف
                                      : AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   widget.book.description!,
                    //   style: TextStyle(color: Colors.white70),
                    // ),
                    SizedBox(height: 16),

                    Text(
                      "Category",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.book.getLocalizedCategory(context),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    SizedBox(height: 25),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          bookTypes.map((type) {
                            bool isSelected = type == selectedType;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedType = type;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Price:${getSelectedPrice()}\$",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Text(
                          "Total: ${formatNumber(totalPrice)}\$",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.primary,
                                ),
                                child: Icon(Icons.remove, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "$quantity",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => quantity++),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.primary,
                                ),
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // تعديل زر إضافة للسلة مع إظهار ملاحظة في وضع الضيف
                    AppButton(
                      text:
                          _isGuest
                              ? "تسجيل الدخول للإضافة للسلة"
                              : "Add to cart",
                      onPressed: _addToCart,
                      height: 55,
                    ),

                    // إضافة إشعار وضع الضيف إذا كان مفعلاً
                    if (_isGuest)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "أنت في وضع الضيف. سجل الدخول للوصول إلى جميع ميزات التطبيق.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 30,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
