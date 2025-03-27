import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_order_entity.dart';

class OrderItemCard extends StatelessWidget {
  final UserOrderEntity order;
  final VoidCallback? onTap;
  final bool isResponsive; 
  const OrderItemCard({
    super.key,
    required this.order,
    this.onTap,
    this.isResponsive = false,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد القيم المتجاوبة
    final bottomMargin = isResponsive ? (context.isTablet ? 20.h : 16.h) : 16.0;
    final cardBorderRadius = isResponsive ? 16.r : 16.0;
    final shadowBlur = isResponsive ? 10.r : 10.0;
    final shadowOffset = isResponsive ? Offset(0, 4.h) : const Offset(0, 4);
    final imageHeight =
        isResponsive ? (context.isTablet ? 160.h : 140.h) : 140.0;
    final badgePadding =
        isResponsive
            ? EdgeInsets.symmetric(
              horizontal: context.isTablet ? 16.w : 12.w,
              vertical: context.isTablet ? 8.h : 6.h,
            )
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final dateBadgeBorderRadius = isResponsive ? 50.r : 50.0;
    final statusBadgeBorderRadius = isResponsive ? 50.r : 50.0;
    const priceBadgeBorderRadius = Radius.circular(16);
    final priceFontSize =
        isResponsive ? (context.isTablet ? 16.sp : 14.sp) : 14.0;
    final titleFontSize =
        isResponsive ? (context.isTablet ? 20.sp : 18.sp) : 18.0;
    final descriptionFontSize =
        isResponsive ? (context.isTablet ? 16.sp : 14.sp) : 14.0;
    final iconSize = isResponsive ? (context.isTablet ? 24.r : 20.r) : 20.0;
    final footerIconSize =
        isResponsive ? (context.isTablet ? 20.r : 16.r) : 16.0;
    final statusMessageFontSize =
        isResponsive ? (context.isTablet ? 16.sp : 14.sp) : 14.0;
    final buttonFontSize =
        isResponsive ? (context.isTablet ? 14.sp : 12.sp) : 12.0;
    final contentPadding = isResponsive ? 16.r : 16.0;

    // تعديل تخطيط البطاقة حسب اتجاه الشاشة لأجهزة التابلت والسطح المكتب
    if (isResponsive && context.isLandscape && !context.isPhone) {
      return _buildLandscapeCard(
        context,
        imageHeight,
        cardBorderRadius,
        shadowBlur,
        shadowOffset,
        badgePadding,
        dateBadgeBorderRadius,
        statusBadgeBorderRadius,
        priceFontSize,
        titleFontSize,
        descriptionFontSize,
        iconSize,
        footerIconSize,
        statusMessageFontSize,
        buttonFontSize,
        contentPadding,
        bottomMargin,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(
                context,
                imageHeight,
                badgePadding,
                dateBadgeBorderRadius,
                statusBadgeBorderRadius,
                priceFontSize,
                iconSize,
              ),
              _buildOrderDetails(
                context,
                contentPadding,
                titleFontSize,
                descriptionFontSize,
              ),
              _buildOrderFooter(
                context,
                footerIconSize,
                statusMessageFontSize,
                buttonFontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء بطاقة في وضع أفقي للشاشات الكبيرة
  Widget _buildLandscapeCard(
    BuildContext context,
    double imageHeight,
    double cardBorderRadius,
    double shadowBlur,
    Offset shadowOffset,
    EdgeInsetsGeometry badgePadding,
    double dateBadgeBorderRadius,
    double statusBadgeBorderRadius,
    double priceFontSize,
    double titleFontSize,
    double descriptionFontSize,
    double iconSize,
    double footerIconSize,
    double statusMessageFontSize,
    double buttonFontSize,
    double contentPadding,
    double bottomMargin,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة على اليمين
              SizedBox(
                width: 200.w, // عرض ثابت للصورة
                child: _buildOrderHeaderLandscape(
                  context,
                  imageHeight,
                  badgePadding,
                  dateBadgeBorderRadius,
                  statusBadgeBorderRadius,
                  priceFontSize,
                  iconSize,
                ),
              ),

              // التفاصيل على اليسار
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderDetails(
                      context,
                      contentPadding,
                      titleFontSize,
                      descriptionFontSize,
                    ),
                    _buildOrderFooter(
                      context,
                      footerIconSize,
                      statusMessageFontSize,
                      buttonFontSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(
    BuildContext context,
    double imageHeight,
    EdgeInsetsGeometry badgePadding,
    double dateBadgeBorderRadius,
    double statusBadgeBorderRadius,
    double priceFontSize,
    double iconSize,
  ) {
    return Stack(
      children: [
        // Product Image
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child:
              order.imageUrl != null
                  ? Image.network(
                    order.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkSecondary,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: iconSize * 2,
                          ),
                        ),
                      );
                    },
                  )
                  : Container(
                    color: AppColors.darkSecondary,
                    child: Center(
                      child: Icon(
                        Icons.book,
                        color: Colors.grey,
                        size: iconSize * 2,
                      ),
                    ),
                  ),
        ),

        // Date badge
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(dateBadgeBorderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: iconSize * 0.7,
                  color: AppColors.primary,  // الألوان الأصلية
                ),
                SizedBox(width: isResponsive ? 4.w : 4),
                Text(
                  order.formattedDate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        isResponsive
                            ? (context.isTablet ? 14.sp : 12.sp)
                            : 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Status badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withOpacity(0.9),
              borderRadius: BorderRadius.circular(statusBadgeBorderRadius),
            ),
            child: Text(
              order.statusText,
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    isResponsive ? (context.isTablet ? 14.sp : 12.sp) : 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Price tag
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isResponsive ? 16.w : 16,
              vertical: isResponsive ? 8.h : 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              '${order.price.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                color: AppColors.secondary,  // الألوان الأصلية
                fontSize: priceFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // نسخة من رأس البطاقة للوضع الأفقي
  Widget _buildOrderHeaderLandscape(
    BuildContext context,
    double imageHeight,
    EdgeInsetsGeometry badgePadding,
    double dateBadgeBorderRadius,
    double statusBadgeBorderRadius,
    double priceFontSize,
    double iconSize,
  ) {
    return Stack(
      children: [
        // Product Image
        SizedBox(
          height: double.infinity, // ملء الارتفاع الكامل
          width: double.infinity,
          child:
              order.imageUrl != null
                  ? Image.network(
                    order.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkSecondary,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: iconSize * 2,
                          ),
                        ),
                      );
                    },
                  )
                  : Container(
                    color: AppColors.darkSecondary,
                    child: Center(
                      child: Icon(
                        Icons.book,
                        color: Colors.grey,
                        size: iconSize * 2,
                      ),
                    ),
                  ),
        ),

        // Status badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withOpacity(0.9),
              borderRadius: BorderRadius.circular(statusBadgeBorderRadius),
            ),
            child: Text(
              order.statusText,
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    isResponsive ? (context.isTablet ? 14.sp : 12.sp) : 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Price tag
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isResponsive ? 16.w : 16,
              vertical: isResponsive ? 8.h : 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              '${order.price.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                color: AppColors.secondary,  // الألوان الأصلية
                fontSize: priceFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(
    BuildContext context,
    double contentPadding,
    double titleFontSize,
    double descriptionFontSize,
  ) {
    return Padding(
      padding: EdgeInsets.all(contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            order.title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if (order.description != null) ...[
            SizedBox(height: isResponsive ? 8.h : 8),
            Text(
              order.description!,
              style: TextStyle(
                fontSize: descriptionFontSize,
                color: Colors.grey[400],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderFooter(
    BuildContext context,
    double footerIconSize,
    double statusMessageFontSize,
    double buttonFontSize,
  ) {
    final isDelivered = order.status == OrderStatus.delivered;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isResponsive ? 16.w : 16,
        vertical: isResponsive ? 12.h : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isResponsive ? 16.r : 16),
          bottomRight: Radius.circular(isResponsive ? 16.r : 16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(order.status),
            size: footerIconSize,
            color: _getStatusColor(order.status),
          ),
          SizedBox(width: isResponsive ? 8.w : 8),
          Text(
            _getStatusMessage(order.status),
            style: TextStyle(
              fontSize: statusMessageFontSize,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          if (isDelivered)
            OutlinedButton.icon(
              onPressed: () {
                // TODO: تنفيذ التحميل
              },
              icon: Icon(Icons.download, size: footerIconSize),
              label: Text('تحميل', style: TextStyle(fontSize: buttonFontSize)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,  // الألوان الأصلية
                side: BorderSide(
                  color: AppColors.primary,  // الألوان الأصلية
                  width: isResponsive ? 1.5 : 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isResponsive ? 50.r : 50),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isResponsive ? 12.w : 12,
                  vertical: 0,
                ),
                minimumSize: Size(
                  0,
                  isResponsive ? (context.isTablet ? 42.h : 36.h) : 36,
                ),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                // TODO: تنفيذ التتبع
              },
              icon: Icon(Icons.location_on, size: footerIconSize),
              label: Text('تتبع', style: TextStyle(fontSize: buttonFontSize)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _getStatusColor(order.status),
                side: BorderSide(
                  color: _getStatusColor(order.status),
                  width: isResponsive ? 1.5 : 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isResponsive ? 50.r : 50),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isResponsive ? 12.w : 12,
                  vertical: 0,
                ),
                minimumSize: Size(
                  0,
                  isResponsive ? (context.isTablet ? 42.h : 36.h) : 36,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.blue;  // الألوان الأصلية
      case OrderStatus.shipped:
        return Colors.orange;  // الألوان الأصلية
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Icons.hourglass_bottom;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'جاري تجهيز طلبك';
      case OrderStatus.shipped:
        return 'طلبك في الطريق إليك';
      case OrderStatus.delivered:
        return 'تم توصيل طلبك بنجاح';
      case OrderStatus.cancelled:
        return 'تم إلغاء الطلب';
    }
  }
}