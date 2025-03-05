import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:united_formation_app/core/core.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final void Function(String) onChanged;
  final TextEditingController? controller;
  final bool autofocus;

  const OtpInputField({
    Key? key,
    this.length = 4,
    required this.onCompleted,
    required this.onChanged,
    this.controller,
    this.autofocus = true,
  }) : super(key: key);

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<String> _otpValues;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _otpValues = List.filled(widget.length, '');
    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    // If a master controller was provided, use it to pre-fill values
    if (widget.controller != null) {
      _updateFieldsFromController();
      
      // Listen for external changes to the controller
      widget.controller!.addListener(_updateFieldsFromController);
    }
  }

  void _updateFieldsFromController() {
    if (widget.controller == null) return;
    
    final text = widget.controller!.text;
    for (int i = 0; i < widget.length && i < text.length; i++) {
      _controllers[i].text = text[i];
      _otpValues[i] = text[i];
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    // Remove listener if controller was provided
    widget.controller?.removeListener(_updateFieldsFromController);
    super.dispose();
  }

  String _getOtpValue() {
    return _otpValues.join();
  }

  void _handleFieldChanged(int index, String value) {
    setState(() {
      if (value.isEmpty) {
        _otpValues[index] = '';
      } else {
        // Accept only the first character if somehow more are entered
        _otpValues[index] = value[0];
      }
    });

    final otp = _getOtpValue();
    widget.onChanged(otp);

    // If the user filled this field, move to the next
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    // If all fields are filled, call onCompleted
    if (otp.length == widget.length && !otp.contains('')) {
      widget.onCompleted(otp);
    }

    // Update master controller if provided
    if (widget.controller != null) {
      widget.controller!.text = otp;
    }
  }

  void _handleBackspace(int index) {
    // If current field is empty and backspace is pressed, move to previous field
    if (_controllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final fieldSize = context.screenWidth * 0.12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: fieldSize,
          height: fieldSize,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: widget.autofocus && index == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: fieldSize * 0.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              counter: const SizedBox.shrink(), // Hide character counter
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkSecondary : Colors.grey.shade50,
            ),
            onChanged: (value) => _handleFieldChanged(index, value),
            onTap: () {
              // Select text when field gets focus for easier overwriting
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
            // Handle backspace key
            onSubmitted: (_) {
              // When user hits "Enter" or "Done", try to complete the OTP
              final otp = _getOtpValue();
              if (otp.length == widget.length && !otp.contains('')) {
                widget.onCompleted(otp);
              }
            },
          ),
        ),
      ),
    );
  }
}