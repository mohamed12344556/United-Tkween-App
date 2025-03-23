import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/support/support_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/support_message_item.dart';
import '../../../../core/routes/routes.dart';

class SupportAdminView extends StatefulWidget {
  const SupportAdminView({super.key});

  @override
  State<SupportAdminView> createState() => _SupportAdminViewState();
}

class _SupportAdminViewState extends State<SupportAdminView> {
  final _messageController = TextEditingController();
  String? _selectedCustomerId;
  String? _selectedCustomerName;

  @override
  void initState() {
    super.initState();
    context.read<SupportAdminCubit>().loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'دعم العملاء'),
      drawer: AdminDrawer(currentRoute: Routes.adminSupportView),
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
            return Column(
              children: [
                _buildHeaderSection(),
                Expanded(
                  child:
                      state.messages.isEmpty
                          ? _buildEmptyMessages()
                          : _buildMessagesList(state),
                ),
                _buildMessageInput(),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          const Text(
            'محادثات الدعم الفني',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
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
          Icon(Icons.message, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد رسائل دعم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر رسائل العملاء هنا عند وصولها',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(SupportLoaded state) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SupportMessageItem(
              message: message,
              onTap: () {
                setState(() {
                  _selectedCustomerId = message.id;
                  _selectedCustomerName = message.customerName;
                });
                if (!message.isRead) {
                  context.read<SupportAdminCubit>().markMessageAsRead(
                    message.id,
                  );
                }

                // Focus the text field and prepare to reply
                FocusScope.of(context).requestFocus(FocusNode());
                _messageController.text = '';
              },
              isSelected: _selectedCustomerId == message.id,
            ),
          );
        },
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
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedCustomerId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'الرد على: $_selectedCustomerName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCustomerId = null;
                        _selectedCustomerName = null;
                        _messageController.clear();
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('إلغاء'),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText:
                        _selectedCustomerId != null
                            ? 'اكتب ردك هنا...'
                            : 'اختر عميل أولاً...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                  enabled: _selectedCustomerId != null,
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color:
                    _selectedCustomerId != null ? Colors.red : Colors.grey[700],
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: _selectedCustomerId != null ? _sendMessage : null,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تحديد عميل للرد عليه'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<SupportAdminCubit>().sendMessage(
      _selectedCustomerId!,
      _messageController.text.trim(),
    );

    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال الرد بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
