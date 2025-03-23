import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:united_formation_app/core/core.dart';
import '../../../../core/helper/format_double_number.dart';
import '../../data/models/order_model.dart';
import '../cubits/orders/orders_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class OrderDetailsAdminView extends StatefulWidget {
  final String orderId;

  const OrderDetailsAdminView({super.key, required this.orderId});

  @override
  State<OrderDetailsAdminView> createState() => _OrderDetailsAdminViewState();
}

class _OrderDetailsAdminViewState extends State<OrderDetailsAdminView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersAdminCubit>().getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'تفاصيل الطلب #${widget.orderId}',
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري طباعة الفاتورة...')),
              );
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(currentRoute: Routes.adminOrdersView),
      body: BlocBuilder<OrdersAdminCubit, OrdersAdminState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const LoadingWidget();
          } else if (state is OrdersError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry:
                  () => context.read<OrdersAdminCubit>().getOrderDetails(
                    widget.orderId,
                  ),
            );
          } else if (state is OrderDetailLoaded) {
            final order = state.order;
            return _buildOrderDetails(context, order);
          } else {
            return const Center(child: Text('حدث خطأ غير متوقع'));
          }
        },
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order),
            const SizedBox(height: 16),
            _buildCustomerInfo(order),
            const SizedBox(height: 16),
            _buildProductsCard(order),
            const SizedBox(height: 16),
            _buildTotalSection(order),
            const SizedBox(height: 16),
            _buildStatusSection(context, order),
            const SizedBox(height: 16),
            _buildActionButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فاتورة طلب رقم ${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.arabicName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd').format(order.date)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'بيانات العميل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            _buildInfoItem(
              icon: Icons.account_circle,
              label: 'الاسم',
              value: order.customerName,
            ),
            _buildInfoItem(
              icon: Icons.phone,
              label: 'رقم الهاتف',
              value: order.customerPhone,
            ),
            _buildInfoItem(
              icon: Icons.location_on,
              label: 'العنوان',
              value: order.customerAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsCard(OrderModel order) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'المنتجات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(3), // Product
                  1: FlexColumnWidth(1.5), // Quantity
                  2: FlexColumnWidth(1.5), // Price
                  3: FlexColumnWidth(1.7), // Total
                },
                children: [
                  _buildTableHeader(),
                  ...order.items.map((item) => _buildTableRow(item)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.red),
      children: [
        _buildTableCell('المنتج', isHeader: true),
        _buildTableCell('الكمية', isHeader: true),
        _buildTableCell('السعر', isHeader: true),
        _buildTableCell('الإجمالي', isHeader: true),
      ],
    );
  }

  TableRow _buildTableRow(OrderItem item) {
    final backgroundColor = AppColors.darkSecondary;

    return TableRow(
      decoration: BoxDecoration(color: backgroundColor),
      children: [
        _buildTableCell(item.productName),
        _buildTableCell(item.quantity.toString()),
        _buildTableCell('${item.price} جنيه'),
        _buildTableCell('${item.totalPrice} جنيه'),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : null,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTotalSection(OrderModel order) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.payment, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'الإجمالي الكلي:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${formatNumber(order.total)} جنيه',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, OrderModel order) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.sync, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'تحديث حالة الطلب',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton(
                  context,
                  'معلقة',
                  OrderStatus.pending,
                  order,
                  color: Colors.orange,
                  icon: Icons.hourglass_empty,
                ),
                _buildStatusButton(
                  context,
                  'قيد المعالجة',
                  OrderStatus.processing,
                  order,
                  color: Colors.blue,
                  icon: Icons.sync,
                ),
                _buildStatusButton(
                  context,
                  'مكتملة',
                  OrderStatus.completed,
                  order,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildStatusButton(
                  context,
                  'ملغية',
                  OrderStatus.cancelled,
                  order,
                  color: Colors.red,
                  icon: Icons.cancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    OrderStatus status,
    OrderModel order, {
    required Color color,
    required IconData icon,
  }) {
    final isSelected = order.status == status;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed:
              isSelected
                  ? null
                  : () {
                    context.read<OrdersAdminCubit>().updateOrderStatus(
                      order.id,
                      status,
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color.withOpacity(0.7) : color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: color,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.message),
            label: const Text('التواصل مع العميل'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري التواصل مع العميل...')),
              );
              context.pushNamed(
                Routes.adminSupportChatView,
                arguments: {
                  'customerId': order.id,
                  'customerName': order.customerName,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.print),
            label: const Text('طباعة الفاتورة'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري طباعة الفاتورة...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
