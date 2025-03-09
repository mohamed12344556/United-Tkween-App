//
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:footwear_store_client/core/utils/styles.dart';
//
// import 'dart:math' as math;
//
// import '../../controller/products_cubit.dart';
// import '../../controller/products_state.dart';
//
// class MultiSelectDropDownBtn extends StatefulWidget {
//   const MultiSelectDropDownBtn({super.key});
//
//   @override
//   State<MultiSelectDropDownBtn> createState() => _MultiSelectDropDownBtnState();
// }
//
// class _MultiSelectDropDownBtnState extends State<MultiSelectDropDownBtn> {
//   @override
//   void initState() {
//     BlocProvider.of<ProductsCubit>(context).fetchAllProductsBrands();
//     print(BlocProvider.of<ProductsCubit>(context).productsBrands);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var cubit = BlocProvider.of<ProductsCubit>(context);
//     List<String> selectedItems = [];
//     return BlocBuilder<ProductsCubit, ProductsStates>(
//       builder: (context, state) {
//       if(state is GetProductSuccessState || cubit.productsBrands.isNotEmpty)
//          {
//           return Card(
//             child: Center(
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2<String>(
//                   isExpanded: true,
//                   hint: Text(
//                     'Filter Brand',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Theme.of(context).hintColor,
//                     ),
//                   ),
//                   items: cubit.productsBrands.map((item) {
//                     return DropdownMenuItem(
//                       value: item.name,
//                       child: StatefulBuilder(
//                         builder: (context, menuSetState) {
//                           final isSelected = selectedItems.contains(item.name);
//                           return InkWell(
//                             onTap: () {
//                               isSelected
//                                   ? selectedItems.remove(item.name)
//                                   : selectedItems.add(item.name);
//                               cubit.filterProductsByBrand(selectedItems);
//                               menuSetState(() {});
//                             },
//                             child: Container(
//                               height: double.infinity,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Row(
//                                 children: [
//                                   if (isSelected)
//                                     const Icon(Icons.check_box_outlined)
//                                   else
//                                     const Icon(Icons.check_box_outline_blank),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       item.name,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }).toList(),
//                   value: selectedItems.isEmpty ? null : selectedItems.last,
//                   onChanged: (value) {
//                     // This is where you handle the change of the selected item
//                     // In this case, you can update the selectedItems list
//                     selectedItems.clear();
//                     if (value != null) {
//                       selectedItems.add(value);
//                     }
//                     cubit.filterProductsByBrand(selectedItems);
//                   },
//                   selectedItemBuilder: (context) {
//                     return cubit.productsBrands.map(
//                       (item) {
//                         return Container(
//                           alignment: AlignmentDirectional.center,
//                           child: Text(
//                             selectedItems.join(', '),
//                             style: const TextStyle(
//                               fontSize: 14,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             maxLines: 1,
//                           ),
//                         );
//                       },
//                     ).toList();
//                   },
//                   buttonStyleData: const ButtonStyleData(
//                     padding: EdgeInsets.only(left: 16, right: 8),
//                     height: 40,
//                     width: 140,
//                   ),
//                   menuItemStyleData: const MenuItemStyleData(
//                     height: 40,
//                     padding: EdgeInsets.zero,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return Card(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(child: SizedBox()),
//                   Text(
//                     'Filter Brand',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                   Expanded(child: SizedBox()),
//                   Icon(
//                     Icons.arrow_drop_down_sharp,
//                     color: Colors.grey,
//                   ),
//                   Expanded(child: SizedBox()),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   Widget customLoadingIndicator() {
//     return Row(
//       children: [
//         Expanded(child: SizedBox()),
//         SizedBox(
//           height: 25,
//           width: 25,
//           child: CircularProgressIndicator(color: AppStyles.kPrimaryColor),
//         ),
//         Expanded(child: SizedBox()),
//       ],
//     );
//   }
// }
