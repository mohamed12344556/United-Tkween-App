import 'package:equatable/equatable.dart';

class SupportMessageModel extends Equatable {
  final String id;
  final String customerName;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const SupportMessageModel({
    required this.id,
    required this.customerName,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        id,
        customerName,
        message,
        timestamp,
        isRead,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'],
      customerName: json['customerName'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  SupportMessageModel copyWith({
    String? id,
    String? customerName,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return SupportMessageModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}