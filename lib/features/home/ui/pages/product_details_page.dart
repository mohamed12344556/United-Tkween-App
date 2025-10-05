import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/core/helper/format_double_number.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../generated/l10n.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../data/book_model.dart';
import '../cubit/home_cubit.dart';

class ProductDetailsPage extends StatefulWidget {
  final String bookId;
  const ProductDetailsPage({super.key, required this.bookId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  BookModel? _book;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final cubit = sl<HomeCubit>();
    final book = await cubit.getBookDetails(widget.bookId);

    if (mounted) {
      setState(() {
        _book = book;
        _isLoading = false;
        _errorMessage = book == null ? 'الكتاب غير موجود' : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    // Show book if found
    if (_book != null) {
      return ProductDetailsPageBody(book: _book!);
    }

    // Show error if failed
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book_outlined, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 24),
              Text(
                'عذراً، الكتاب غير موجود',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('العودة للصفحة الرئيسية'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading
    return const Center(child: CircularProgressIndicator());
  }
}

class ProductDetailsPageContent extends StatefulWidget {
  final String bookId;
  const ProductDetailsPageContent({super.key, required this.bookId});

  @override
  State<ProductDetailsPageContent> createState() =>
      _ProductDetailsPageContentState();
}

class _ProductDetailsPageContentState extends State<ProductDetailsPageContent> {
  BookModel? _cachedBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // Cache the book when we get it successfully
          if (state is BookDetailsSuccessState) {
            _cachedBook = state.book;
          }

          // Always display cached book if we have it
          if (_cachedBook != null) {
            return ProductDetailsPageBody(book: _cachedBook!);
          }

          // Failure State
          if (state is BookDetailsFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'عذراً، الكتاب غير موجود',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('العودة للصفحة الرئيسية'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loading State (only shown initially when we have no cached book)
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProductDetailsPageBody extends StatefulWidget {
  final BookModel book;

  const ProductDetailsPageBody({super.key, required this.book});

  @override
  State<ProductDetailsPageBody> createState() => _ProductDetailsPageBodyState();
}

class _ProductDetailsPageBodyState extends State<ProductDetailsPageBody> {
  late String selectedType;
  bool _isGuest = false;
  bool _isDescriptionExpanded = false;
  bool _shouldShowReadMore = false;

  @override
  void initState() {
    super.initState();
    selectedType = (widget.book.getFormattedPdfPrice == 0) ? "paper" : "PDF";
    _checkGuestStatus();

    // تحديد ما إذا كان النص طويلاً بما فيه الكفاية لإظهار "عرض المزيد"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDescriptionLength();
    });
  }

  void _checkDescriptionLength() {
    if (widget.book.description.isEmpty) return;

    // حساب عدد الأسطر المطلوبة للنص
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.book.description,
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      textDirection: TextDirection.rtl,
      maxLines: null,
    );

    // استخدام عرض الشاشة مع تقليل المساحة للحواف
    final maxWidth = MediaQuery.of(context).size.width - 32;
    textPainter.layout(maxWidth: maxWidth);

    // حساب عدد الأسطر الفعلية
    final numberOfLines = textPainter.computeLineMetrics().length;

    setState(() {
      _shouldShowReadMore = numberOfLines > 3;
    });
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

  // دالة إنشاء رابط المنتج
  String _generateProductLink() {
    // استخدام deep link بدلاً من HTTP link
    // return DeepLinkService.generateProductLink(
    //   widget.book.id.toString(),
    //   productName: widget.book.title,
    // );
    final link = "https://tkweenstore.com/product/${widget.book.id}";
    return link;
  }

  // دالة نسخ الرابط
  Future<void> _copyProductLink() async {
    final productLink = _generateProductLink();
    await Clipboard.setData(ClipboardData(text: productLink));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم نسخ رابط المنتج',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // دالة مشاركة المنتج
  Future<void> _shareProduct() async {
    final productLink = _generateProductLink();
    final shareText = '''
شاهد هذا الكتاب الرائع: ${widget.book.title}

${widget.book.description.isNotEmpty ? '${widget.book.description.length > 100 ? "${widget.book.description.substring(0, 100)}..." : widget.book.description}\n\n' : ''}السعر: ${getSelectedPrice()} ر.س

الرابط: $productLink

تطبيق تكوين للكتب - اكتشف عالم من المعرفة
''';

    await Share.share(shareText, subject: 'كتاب ${widget.book.title}');
  }

  // دالة إظهار خيارات المشاركة
  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مؤشر السحب
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'مشاركة المنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              SizedBox(height: 20),

              // خيار نسخ الرابط
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.copy, color: AppColors.primary),
                ),
                title: Text(
                  'نسخ الرابط',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                subtitle: Text(
                  'نسخ رابط المنتج إلى الحافظة',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _copyProductLink();
                },
              ),

              Divider(),

              // خيار المشاركة
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share, color: AppColors.primary),
                ),
                title: Text(
                  'مشاركة',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                subtitle: Text(
                  'مشاركة المنتج مع الآخرين',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareProduct();
                },
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
          content: Text(
            'تمت الإضافة إلى السلة!',
            style: TextStyle(color: Colors.white),
          ),
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
          content: Text(
            'تمت إزالة الكتاب من المفضلة',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      // إضافة الكتاب إلى المفضلة
      favoritesBox.put(widget.book.id, widget.book);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تمت إضافة الكتاب إلى المفضلة',
            style: TextStyle(color: Colors.white),
          ),
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
    bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: widget.book.id,
            child: Container(
              height: MediaQuery.of(context).size.height * .7,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // fit: BoxFit.cover,
                  fit: isTablet ? BoxFit.fill : BoxFit.cover,
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
                // top: MediaQuery.of(context).size.height * .5,
                top: MediaQuery.of(context).size.height * .7,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
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
                              color: AppColors.text,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // إضافة زر المشاركة
                        GestureDetector(
                          onTap: _showShareOptions,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.share,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),

                        // زر المفضلة الموجود
                        GestureDetector(
                          onTap: _addToFavorites,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isGuest ? Colors.grey : AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // قسم وصف الكتاب
                    if (widget.book.description.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الوصف",
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),

                          // النص مع إمكانية التوسيع
                          AnimatedCrossFade(
                            firstChild: Text(
                              widget.book.description,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            secondChild: Text(
                              widget.book.description,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            crossFadeState:
                                _isDescriptionExpanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 300),
                          ),

                          // زر "عرض المزيد" يظهر فقط إذا كان النص طويلاً
                          if (_shouldShowReadMore) ...[
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isDescriptionExpanded =
                                      !_isDescriptionExpanded;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isDescriptionExpanded
                                        ? "عرض أقل"
                                        : "عرض المزيد",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    _isDescriptionExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],

                          Divider(height: 24, color: Colors.grey.shade300),
                        ],
                      ),
                    ],

                    SizedBox(height: 16),

                    Text(
                      "القسم",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.book.getLocalizedCategory(context),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 25),
                    if (!Platform.isIOS) ...[
                      Text(
                        "نوع الكتاب",
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
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
                                            : AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    type.convertBookTypeToArabic(),
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.text,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 25),
                    ],

                    // if (!Platform.isIOS) ...[
                    //   Text(
                    //     "Price: ${getSelectedPrice()} ر.س",
                    //     style: TextStyle(
                    //       color: AppColors.text,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   SizedBox(height: 16),

                    //   Row(
                    //     children: [
                    //       Text(
                    //         "Total: ${formatNumber(totalPrice)} ر.س",
                    //         style: TextStyle(
                    //           color: AppColors.primary,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       Spacer(),
                    //       Row(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               if (quantity > 1) {
                    //                 setState(() => quantity--);
                    //               }
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.all(4),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 color: AppColors.primary,
                    //               ),
                    //               child: Icon(
                    //                 Icons.remove,
                    //                 color: Colors.white,
                    //                 size: 16,
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 10,
                    //             ),
                    //             child: Text(
                    //               "$quantity",
                    //               style: TextStyle(
                    //                 color: AppColors.text,
                    //                 fontSize: 20,
                    //               ),
                    //             ),
                    //           ),
                    //           GestureDetector(
                    //             onTap: () => setState(() => quantity++),
                    //             child: Container(
                    //               padding: EdgeInsets.all(4),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 color: AppColors.primary,
                    //               ),
                    //               child: Icon(
                    //                 Icons.add,
                    //                 color: Colors.white,
                    //                 size: 16,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ],
                    Text(
                      "السعر: ${getSelectedPrice()} ر.س",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // SizedBox(height: 16),

                    // Row(
                    //   children: [
                    //     Text(
                    //       "الإجمالي: ${formatNumber(totalPrice)} ر.س",
                    //       style: TextStyle(
                    //         color: AppColors.primary,
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Spacer(),
                    //     if (0 > 1) ...[
                    //       Row(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               if (quantity > 1) {
                    //                 setState(() => quantity--);
                    //               }
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.all(4),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 color: AppColors.primary,
                    //               ),
                    //               child: Icon(
                    //                 Icons.remove,
                    //                 color: Colors.white,
                    //                 size: 16,
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 10,
                    //             ),
                    //             child: Text(
                    //               "$quantity",
                    //               style: TextStyle(
                    //                 color: AppColors.text,
                    //                 fontSize: 20,
                    //               ),
                    //             ),
                    //           ),
                    //           GestureDetector(
                    //             onTap: () => setState(() => quantity++),
                    //             child: Container(
                    //               padding: EdgeInsets.all(4),
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 color: AppColors.primary,
                    //               ),
                    //               child: Icon(
                    //                 Icons.add,
                    //                 color: Colors.white,
                    //                 size: 16,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ],
                    // ),
                    SizedBox(height: 30),

                    // تعديل زر إضافة للسلة مع إظهار ملاحظة في وضع الضيف
                    // if (!Platform.isIOS) ...[
                    //   AppButton(
                    //     text:
                    //         _isGuest
                    //             ? "تسجيل الدخول للإضافة للسلة"
                    //             : "Add to cart",
                    //     onPressed: _addToCart,
                    //     height: 55,
                    //     backgroundColor: AppColors.primary,
                    //     textColor: Colors.white,
                    //   ),
                    // ],
                    AppButton(
                      text:
                          _isGuest
                              ? S.of(context).loginToCart
                              : S.of(context).addToCart,
                      onPressed: _addToCart,
                      height: 55,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),

                    // if (Platform.isMacOS) ...[
                    //   AppButton(
                    //     text: "View Book Details",
                    //     onPressed: () {
                    //       launchUrl(Uri.parse('https://tkweenstore.com/'));
                    //     },
                    //     height: 55,
                    //     backgroundColor: AppColors.primary,
                    //     textColor: Colors.white,
                    //   ),
                    // ],

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
                                  S.of(context).guestModeDesc,
                                  style: TextStyle(
                                    color: AppColors.text,
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
                height: 40,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
