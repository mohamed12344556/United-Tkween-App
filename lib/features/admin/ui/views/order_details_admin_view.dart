import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/order_model.dart';
import '../cubits/orders/orders_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
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
      appBar: const AdminAppBar(title: 'تفاصيل الطلب'),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(order),
                    const SizedBox(height: 24),
                    _buildCustomerInfo(order),
                    const SizedBox(height: 24),
                    _buildProductsTable(order),
                    const SizedBox(height: 24),
                    _buildTotalSection(order),
                    const SizedBox(height: 24),
                    _buildStatusSection(context, order),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('حدث خطأ غير متوقع'));
          }
        },
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Text(
              'التاريخ: ${DateFormat('yyyy-MM-dd').format(order.date)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'بيانات العميل:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('الاسم:', order.customerName),
            const SizedBox(height: 8),
            _buildInfoRow('رقم الهاتف:', order.customerPhone),
            const SizedBox(height: 8),
            _buildInfoRow('العنوان:', order.customerAddress),
            const SizedBox(height: 8),
            _buildInfoRow('حالة الطلب:', order.status.arabicName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildProductsTable(OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المنتجات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(3), // Product
                1: FlexColumnWidth(1), // Quantity
                2: FlexColumnWidth(1), // Price
                3: FlexColumnWidth(1), // Total
              },
              children: [
                _buildTableHeader(),
                ...order.items.map((item) => _buildTableRow(item)).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.red),
      children: [
        _buildTableCell('المنتج', isHeader: true),
        _buildTableCell('الكمية', isHeader: true),
        _buildTableCell('السعر', isHeader: true),
        _buildTableCell('الإجمالي', isHeader: true),
      ],
    );
  }

  TableRow _buildTableRow(OrderItem item) {
    return TableRow(
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : null,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTotalSection(OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الإجمالي الكلي:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${order.total} جنيه',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تحديث حالة الطلب:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusButton(
                  context,
                  'معلقة',
                  OrderStatus.pending,
                  order,
                ),
                _buildStatusButton(
                  context,
                  'قيد المعالجة',
                  OrderStatus.processing,
                  order,
                ),
                _buildStatusButton(
                  context,
                  'مكتملة',
                  OrderStatus.completed,
                  order,
                ),
                _buildStatusButton(
                  context,
                  'ملغية',
                  OrderStatus.cancelled,
                  order,
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
    OrderModel order,
  ) {
    final isSelected = order.status == status;
    return ElevatedButton(
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
        backgroundColor: isSelected ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.green,
        disabledForegroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }
}
