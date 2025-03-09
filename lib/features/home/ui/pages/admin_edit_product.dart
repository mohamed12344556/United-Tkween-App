import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import '../../data/product_model.dart';

class AdminEditProductPage extends StatefulWidget {
  final ProductModel product;

  const AdminEditProductPage({super.key, required this.product});

  @override
  State<AdminEditProductPage> createState() => _AdminEditProductPageState();
}

class _AdminEditProductPageState extends State<AdminEditProductPage> {
  var formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  late TextEditingController productPriceController;

  @override
  void initState() {
    productNameController = TextEditingController();
    productDescriptionController = TextEditingController();
    productPriceController = TextEditingController();
    productNameController.text = widget.product.name;
    productDescriptionController.text = widget.product.description;
    productPriceController.text = widget.product.price.toString();
    super.initState();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Edit Product ',
                  style: TextStyle(fontSize: 30, color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Product Name ',
                  hintText: 'Enter Your Product name',
                  controller: productNameController,
                  validator:
                      (value) => validateTextFieldInput(
                        value,
                        errorMsg: 'Product Name Required ',
                      ),
                  autovalidateMode: autoValidateMode,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Product Description ',
                  hintText: widget.product.description,
                  maxLines: 4,
                  controller: productDescriptionController,
                  validator:
                      (value) => validateTextFieldInput(
                        value,
                        errorMsg: 'Product Description Required ',
                      ),
                  autovalidateMode: autoValidateMode,
                ),
                const SizedBox(height: 20),

                AppTextField(
                  labelText: 'Product Image Url ',
                  hintText: 'Enter Your Image Url',
                  // controller: cubit.productImageUrlController,
                  // validator : (value)
                  // {
                  //   if (value!.isEmpty && cubit.productImageFile == null) {
                  //     return 'Product Image Url Required ';
                  //   }
                  //   return null;
                  // } ,
                  validator:
                      (value) => validateTextFieldInput(
                        value,
                        errorMsg: 'Product Image Required ',
                      ),
                  autovalidateMode: autoValidateMode,
                ),
                const SizedBox(height: 8),
                const Text('OR', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    ///Upload Image Here
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16 , horizontal:16),
                      child: Row(
                        children: [
                          const Text(
                            'Upload Your Image ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.upload),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (state is UploadImageLoadingState)
                //   const Padding(
                //     padding: EdgeInsets.all(20),
                //     child: LinearProgressIndicator(),
                //   ),
                const SizedBox(height: 25),
                AppTextField(
                  labelText: 'Product Price ',
                  hintText: 'Enter Your Product Price',
                  controller: productPriceController,
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => validateTextFieldInput(
                        value,
                        errorMsg: 'Product Price Required ',
                      ),
                  autovalidateMode: autoValidateMode,
                ),
                const SizedBox(height: 25),

                AppButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // ProductModel updatedProduct =
                      //     widget.product.copyWith(
                      //   name: productNameController.text,
                      //   description: productDescriptionController.text,
                      //   price: double.tryParse(
                      //       productPriceController.text),
                      //   imageUrl: cubit.productImageUrlController.text,
                      //   category: cubit.selectedCategory,
                      //   brand: cubit.selectedBrand,
                      //   offer: cubit.selectedOffer == 'true',
                      // );

                      ProductModel updatedProduct = widget.product.copyWith(
                        name: productNameController.text,
                        description: productDescriptionController.text,
                        price: double.tryParse(productPriceController.text),
                      );
                    } else {
                      autoValidateMode = AutovalidateMode.always;
                      setState(() {});
                    }
                  },
                  text: '  Update Product  ',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateTextFieldInput(String? value, {required String errorMsg}) {
    if (value?.isEmpty ?? true) {
      return errorMsg;
    }
    return null;
  }
}
