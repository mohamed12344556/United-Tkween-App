import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/admin/data/models/support_message_model.dart';
import '../cubits/support/support_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../../../../core/routes/routes.dart';
import 'package:intl/intl.dart';

class SupportChatAdminView extends StatefulWidget {
  final String customerId;
  final String customerName;

  const SupportChatAdminView({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<SupportChatAdminView> createState() => _SupportChatAdminViewState();
}

class _SupportChatAdminViewState extends State<SupportChatAdminView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // تحميل الرسائل عند بدء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportAdminCubit>().loadMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'محادثة ${widget.customerName}'),
      drawer: const AdminDrawer(currentRoute: Routes.adminSupportView),
      backgroundColor: Colors.black,
      body: BlocBuilder<SupportAdminCubit, SupportAdminState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const LoadingWidget();
          } else if (state is SupportError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () => context.read<SupportAdminCubit>().loadMessages(),
            );
          } else if (state is SupportLoaded) {
            // تصفية الرسائل لهذا العميل فقط
            final filteredMessages =
                state.messages
                    .where((msg) => msg.id == widget.customerId)
                    .toList();

            return Column(
              children: [
                _buildChatHeader(),
                Expanded(
                  child:
                      filteredMessages.isEmpty
                          ? _buildEmptyMessages()
                          : _buildMessagesList(filteredMessages),
                ),
                _buildMessageInput(),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'حدث خطأ غير متوقع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('العودة'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: Text(
              widget.customerName.isNotEmpty
                  ? widget.customerName.substring(0, 1).toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'رقم العميل: ${widget.customerId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<SupportAdminCubit>().loadMessages(),
            tooltip: 'تحديث',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد رسائل مع هذا العميل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ محادثة جديدة مع العميل',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<SupportMessageModel> messages) {
    // ترتيب الرسائل حسب التاريخ
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(SupportMessageModel message) {
    final isUserMessage = message.customerName == widget.customerName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUserMessage) ...[
            CircleAvatar(
              backgroundColor: Colors.grey[700],
              radius: 18,
              child: Text(
                message.customerName.isNotEmpty
                    ? message.customerName.substring(0, 1).toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.grey[800] : Colors.red.shade900,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUserMessage ? Radius.zero : null,
                  bottomRight: !isUserMessage ? Radius.zero : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUserMessage ? Colors.white : Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatDateTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            isUserMessage ? Colors.grey[400] : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isUserMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 18,
              child: const Text(
                'أنا',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[800],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.red,
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
            elevation: 2,
            child: InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    context.read<SupportAdminCubit>().sendMessage(
      widget.customerId,
      _messageController.text.trim(),
    );

    _messageController.clear();
    _scrollToBottom();

    // إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال الرسالة بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today, show time only
      return 'اليوم ${DateFormat.jm().format(dateTime)}';
    } else if (messageDate == yesterday) {
      // Yesterday
      return 'أمس ${DateFormat.jm().format(dateTime)}';
    } else {
      // Not today, show date and time
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }
}
