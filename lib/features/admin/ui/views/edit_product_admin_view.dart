import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:united_formation_app/features/admin/data/models/product_model.dart';
import '../cubits/edit_product/edit_product_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/loading_widget.dart';

class EditProductAdminView extends StatefulWidget {
  final ProductModel product;

  const EditProductAdminView({super.key, required this.product});

  @override
  State<EditProductAdminView> createState() => _EditProductAdminViewState();
}

class _EditProductAdminViewState extends State<EditProductAdminView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;
  late String _selectedType;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  final List<String> _categories = [
    'كتب التنمية',
    'الكتب الأدبية',
    'كتب علمية',
    'كتب دينية',
    'قصص وروايات',
  ];

  final List<String> _types = ['مطبوع', 'PDF', 'صوتي'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description ?? '',
    );
    _selectedCategory = widget.product.category;
    _selectedType = widget.product.type ?? 'PDF';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في اختيار الصورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'تعديل المنتج'),
      body: BlocConsumer<EditProductAdminCubit, EditProductAdminState>(
        listener: (context, state) {
          if (state is EditProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is EditProductLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'اسم المنتج',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'القسم',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'نوع الكتاب',
                      value: _selectedType,
                      items: _types,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _priceController,
                      label: 'السعر',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال سعر المنتج';
                        }
                        if (double.tryParse(value) == null) {
                          return 'يرجى إدخال سعر صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _quantityController,
                      label: 'الكمية',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الكمية';
                        }
                        if (int.tryParse(value) == null) {
                          return 'يرجى إدخال كمية صحيحة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'الوصف',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _buildImageUploadSection(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'تحديث المنتج',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.red,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.grey[800]),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.grey[800],
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.red),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.image, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'رفع صور المنتج',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? _buildSelectedImagePreview()
                : _buildImageUploadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(_selectedImage!.path),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedImage!.name,
                style: const TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: _pickImage,
                  tooltip: 'تغيير',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                  tooltip: 'حذف',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploadButton() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade600, width: 2),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_upload, color: Colors.red, size: 48),
              SizedBox(height: 8),
              Text('اضغط لاختيار صورة', style: TextStyle(color: Colors.white)),
              Text(
                'أو اسحب وأفلت الملف هنا',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateForm() {
    if (_formKey.currentState!.validate()) {
      // في الحالة الحقيقية، ستحتاج لرفع الصورة أولاً والحصول على رابطها
      // ثم تمريره إلى إضافة المنتج
      String? imageUrl;
      if (_selectedImage != null) {
        // هنا ستقوم بالفعل بعملية رفع الملف إلى الخادم والحصول على الرابط
        // imageUrl = await uploadImage(_selectedImage!);

        // للاختبار، سنستخدم مسار ملف محلي
        imageUrl = _selectedImage!.path;
      }

      context.read<EditProductAdminCubit>().updateProduct(
        name: _nameController.text,
        category: _selectedCategory,
        type: _selectedType == 'مطبوع' ? null : _selectedType,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        description: _descriptionController.text,
        imageUrl: imageUrl,
      );
    }
  }
}
