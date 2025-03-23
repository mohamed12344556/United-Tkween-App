import 'package:flutter/material.dart';

/// مغلف آمن لـ TextEditingController للتعامل مع حالات التخلص منه
class SafeTextEditingController extends TextEditingController {
  bool _isDisposed = false;
  
  /// التحقق مما إذا كان قد تم التخلص من الـ controller
  bool get isDisposed => _isDisposed;
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  @override
  set text(String newText) {
    if (!_isDisposed) {
      super.text = newText;
    }
  }
  
  @override
  void clear() {
    if (!_isDisposed) {
      super.clear();
    }
  }
}