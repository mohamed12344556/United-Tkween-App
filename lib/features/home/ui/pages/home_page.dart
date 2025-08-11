// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/core/core.dart';
// import 'package:united_formation_app/features/home/data/book_model.dart';
// import 'package:united_formation_app/features/home/ui/cubit/home_cubit.dart';
// import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_cubit.dart';
// import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_state.dart';
// import '../widgets/home_products_grid_view.dart';
// import '../widgets/home_widgets/categories_listview.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with AutomaticKeepAliveClientMixin {
//   final TextEditingController searchController = TextEditingController();
//   List<BookModel> filteredBooks = [];

//   // محركات الحالة كخصائص للكلاس
//   late final HomeCubit _homeCubit;
//   late final ProfileCubit _profileCubit;

//   @override
//   bool get wantKeepAlive => true; // للحفاظ على حالة الصفحة عند التنقل

//   @override
//   void initState() {
//     super.initState();
//     _homeCubit = sl<HomeCubit>();
//     _profileCubit = sl<ProfileCubit>();

//     // تحميل البيانات
//     _initData();
//   }

//   Future<void> _initData() async {
//     // تحميل البيانات بالتوازي
//     await Future.wait([
//       Future(() => _homeCubit.getHomeBooks()),
//       Future(() => _profileCubit.loadProfile()),
//     ]);
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

// void filterBooks(String query, List<BookModel> allBooks) {
//   if (query.isEmpty) {
//     setState(() => filteredBooks = []);
//     return;
//   }

//   final tempBooks =
//       allBooks
//           .where(
//             (book) =>
//                 book.title.toLowerCase().contains(query.toLowerCase()) ||
//                 book
//                     .getLocalizedCategory(context)
//                     .toLowerCase()
//                     .contains(query.toLowerCase()),
//           )
//           .toList();

//   setState(() => filteredBooks = tempBooks);
// }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // مطلوب للـ AutomaticKeepAliveClientMixin

//     final screenHeight = MediaQuery.of(context).size.height;

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: _homeCubit),
//         BlocProvider.value(value: _profileCubit),
//       ],
//       child: Scaffold(
//         backgroundColor: AppColors.darkBackground,
//         appBar: _buildAppBar(context),
//         body: _buildBody(context, screenHeight),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context, double screenHeight) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: RefreshIndicator(
//         onRefresh: _initData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minHeight: screenHeight),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildSearchField(),
//                 const SizedBox(height: 20),
//                 _buildCategoriesSection(),
//                 const SizedBox(height: 20),
//                 _buildPopularHeader(),
//                 const SizedBox(height: 20),
//                 _buildBooksGrid(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         return TextFormField(
//           controller: searchController,
//           onChanged: (query) => filterBooks(query, _homeCubit.books),
//           decoration: InputDecoration(
//             hintText: 'Search',
//             prefixIcon: const Icon(Icons.search),
//             fillColor: AppColors.inputBackgroundDark,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoriesSection() {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         if (_homeCubit.booksCategories.isNotEmpty) {
//           return CategoriesListView(categoryItems: _homeCubit.booksCategories);
//         } else if (state is HomeCategoriesFailureState) {
//           return Center(
//             child: Column(
//               children: [
//                 const Text("خطأ في تحميل الفئات، يرجى المحاولة مرة أخرى"),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () => _homeCubit.getBooksCategories(),
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all(AppColors.primary),
//                   ),
//                   child: const Text("إعادة المحاولة"),
//                 ),
//               ],
//             ),
//           );
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget _buildPopularHeader() {
//     return const Text(
//       "Popular",
//       style: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     );
//   }

//   Widget _buildBooksGrid() {
//     return BlocBuilder<HomeCubit, HomeState>(
//       buildWhen: (previous, current) {
//         return current is HomeBooksSuccessState ||
//             current is HomeBooksFailureState ||
//             current is HomeBooksLoadingState;
//       },
//       builder: (context, state) {
//         if (state is HomeBooksLoadingState) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is HomeBooksSuccessState) {
//           final books = state.books;

//           if (books.isEmpty) {
//             return const Center(
//               child: Text(
//                 "لا توجد كتب في هذه الفئة",
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           // استخدام filteredBooks إذا كان هناك بحث محلي
//           final displayBooks =
//               filteredBooks.isNotEmpty && searchController.text.isNotEmpty
//                   ? filteredBooks
//                   : books;

//           return HomeProductsGridView(books: displayBooks);
//         } else if (state is HomeBooksFailureState) {
//           return Center(
//             child: Column(
//               children: [
//                 const Text(
//                   "خطأ، يرجى المحاولة مرة أخرى",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () => _homeCubit.getHomeBooks(),
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStateProperty.all(AppColors.primary),
//                   ),
//                   child: const Text("إعادة المحاولة"),
//                 ),
//               ],
//             ),
//           );
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.darkBackground,
//       leading: const Icon(Icons.person, color: Colors.white),
//       title: BlocBuilder<ProfileCubit, ProfileState>(
//         builder: (context, state) {
//           if (state.isSuccess && state.profile != null) {
//             // عرض اسم المستخدم إذا كان متاحاً
//             return Text(
//               state.profile!.fullName,
//               style: const TextStyle(color: Colors.white),
//             );
//           } else {
//             // عرض اسم افتراضي إذا لم يكن الاسم متاحاً بعد
//             return const Text(
//               'مستخدم تكوين',
//               style: TextStyle(color: Colors.white),
//             );
//           }
//         },
//       ),
//       centerTitle: false,
//       actions: [
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: AppColors.darkSecondary,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Icon(
//               Icons.notifications_none,
//               color: AppColors.primary,
//               size: 20,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//       ],
//       scrolledUnderElevation: 0,
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';
import 'package:united_formation_app/features/home/ui/cubit/home_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_state.dart';
import '../../../../generated/l10n.dart';
import '../widgets/home_products_grid_view.dart';
import '../widgets/home_widgets/categories_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  List<BookModel> filteredBooks = [];

  // محركات الحالة كخصائص للكلاس
  late final HomeCubit _homeCubit;
  late final ProfileCubit _profileCubit;

  @override
  bool get wantKeepAlive => true; // للحفاظ على حالة الصفحة عند التنقل

  @override
  void initState() {
    super.initState();
    _homeCubit = sl<HomeCubit>();
    _profileCubit = sl<ProfileCubit>();

    // تحميل البيانات
    _initData();
  }

  Future<void> _initData() async {
    // تحميل البيانات بالتوازي
    await Future.wait([
      Future(() => _homeCubit.getHomeBooks()),
      Future(() => _profileCubit.loadProfile()),
    ]);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // void filterBooks(String query, List<BookModel> allBooks) {
  //   if (query.isEmpty) {
  //     setState(() => filteredBooks = []);
  //     return;
  //   }

  //   final tempBooks =
  //       allBooks
  //           .where(
  //             (book) =>
  //                 book.title.toLowerCase().contains(query.toLowerCase()) ||
  //                 book
  //                     .getLocalizedCategory(context)
  //                     .toLowerCase()
  //                     .contains(query.toLowerCase()),
  //           )
  //           .toList();

  //   setState(() => filteredBooks = tempBooks);
  // }
  void filterBooks(String query, List<BookModel> allBooks) {
    // تنظيف النص المدخل من المسافات الزائدة
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      setState(() => filteredBooks = []);
      return;
    }

    // تحسين طريقة البحث وإضافة المزيد من الحقول للبحث
    final tempBooks =
        allBooks.where((book) {
          // البحث في العنوان
          final titleMatch = book.title.toLowerCase().contains(
            trimmedQuery.toLowerCase(),
          );

          // البحث في الفئة المخصصة للغة
          final categoryMatch = book
              .getLocalizedCategory(context)
              .toLowerCase()
              .contains(trimmedQuery.toLowerCase());

          // يمكن إضافة المزيد من الحقول للبحث إذا كانت متوفرة
          // مثل البحث في الوصف أو المؤلف
          final otherFieldsMatch = false; // قم بتغييره إذا كان هناك حقول أخرى

          return titleMatch || categoryMatch || otherFieldsMatch;
        }).toList();

    // تسجيل نتائج البحث للتصحيح
    debugPrint('بحث عن: "$trimmedQuery"');
    debugPrint('عدد الكتب الأصلية: ${allBooks.length}');
    debugPrint('عدد النتائج: ${tempBooks.length}');

    setState(() => filteredBooks = tempBooks);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مطلوب للـ AutomaticKeepAliveClientMixin
    context.initResponsive();
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context, screenHeight),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: _initData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                const SizedBox(height: 20),
                _buildCategoriesSection(),
                const SizedBox(height: 20),
                _buildPopularHeader(),
                const SizedBox(height: 20),
                _buildBooksGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildSearchField() {
  //   return BlocBuilder<HomeCubit, HomeState>(
  //     builder: (context, state) {
  //       return TextFormField(
  //         controller: searchController,
  //         onChanged: (query) => filterBooks(query, _homeCubit.books),
  //         cursorColor: AppColors.primary,
  //         cursorWidth: 1.5,
  //         cursorRadius: const Radius.circular(2),
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Colors.black,
  //           fontWeight: FontWeight.normal,
  //         ),
  //         decoration: InputDecoration(
  //           hintText: 'Search',
  //           prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
  //           fillColor: AppColors.lightGrey,
  //           filled: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(25.0),
  //             borderSide: BorderSide.none,
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(25.0),
  //             borderSide: BorderSide(color: AppColors.primary, width: 1.5),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(25.0),
  //             borderSide: BorderSide.none,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildSearchField() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeBooksLoadingState;

        return TextFormField(
          controller: searchController,
          onChanged: (query) => filterBooks(query, _homeCubit.books),
          enabled: !isLoading && _homeCubit.books.isNotEmpty,
          cursorColor: AppColors.primary,
          cursorWidth: 1.5,
          cursorRadius: const Radius.circular(2),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: S.of(context).searchBook,
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.textSecondary),
                      onPressed: () {
                        searchController.clear();
                        filterBooks('', _homeCubit.books);
                      },
                    )
                    : null,
            fillColor: AppColors.lightGrey,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (_homeCubit.booksCategories.isNotEmpty) {
          return CategoriesListView(categoryItems: _homeCubit.booksCategories);
        } else if (state is HomeCategoriesFailureState) {
          return Center(
            child: Column(
              children: [
                Text(
                  S.of(context).fetchCategoriesError,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _homeCubit.getBooksCategories(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text(S.of(context).retry),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.secondary.withValues(alpha: 51),
            strokeWidth: context.isTablet ? 3.0 : 2.0,
          ),
        );
      },
    );
  }

  Widget _buildPopularHeader() {
    return Text(
      S.of(context).popular,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  // Widget _buildBooksGrid() {
  //   return BlocBuilder<HomeCubit, HomeState>(
  //     buildWhen: (previous, current) {
  //       return current is HomeBooksSuccessState ||
  //           current is HomeBooksFailureState ||
  //           current is HomeBooksLoadingState;
  //     },
  //     builder: (context, state) {
  //       if (state is HomeBooksLoadingState) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: AppColors.primary,
  //             backgroundColor: AppColors.secondary.withValues(alpha: 51),
  //             strokeWidth: context.isTablet ? 3.0 : 2.0,
  //           ),
  //         );
  //       } else if (state is HomeBooksSuccessState) {
  //         final books = state.books;

  //         if (books.isEmpty) {
  //           return const Center(
  //             child: Text(
  //               "لا توجد كتب في هذه الفئة",
  //               style: TextStyle(color: Colors.black87),
  //             ),
  //           );
  //         }

  //         // استخدام filteredBooks إذا كان هناك بحث محلي
  //         final displayBooks =
  //             filteredBooks.isNotEmpty && searchController.text.isNotEmpty
  //                 ? filteredBooks
  //                 : books;

  //         return HomeProductsGridView(books: displayBooks);
  //       } else if (state is HomeBooksFailureState) {
  //         return Center(
  //           child: Column(
  //             children: [
  //               const Text(
  //                 "خطأ، يرجى المحاولة مرة أخرى",
  //                 style: TextStyle(color: Colors.black87),
  //               ),
  //               const SizedBox(height: 10),
  //               ElevatedButton(
  //                 onPressed: () => _homeCubit.getHomeBooks(),
  //                 style: ButtonStyle(
  //                   backgroundColor: WidgetStateProperty.all(AppColors.primary),
  //                   foregroundColor: WidgetStateProperty.all(Colors.white),
  //                 ),
  //                 child: const Text("إعادة المحاولة"),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       return Center(
  //   child: CircularProgressIndicator(
  //     color: AppColors.primary,
  //     backgroundColor: AppColors.secondary.withValues(alpha: 51),
  //     strokeWidth: context.isTablet ? 3.0 : 2.0,
  //   ),
  // );
  //     },
  //   );
  // }

  Widget _buildBooksGrid() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        return current is HomeBooksSuccessState ||
            current is HomeBooksFailureState ||
            current is HomeBooksLoadingState;
      },
      builder: (context, state) {
        if (state is HomeBooksLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.secondary.withValues(alpha: 51),
              strokeWidth: context.isTablet ? 3.0 : 2.0,
            ),
          );
        } else if (state is HomeBooksSuccessState) {
          final books = state.books;

          if (books.isEmpty) {
            return Center(
              child: Text(
                S.of(context).noBooksInCategory,
                style: TextStyle(color: Colors.black87),
              ),
            );
          }

          // استخدام filteredBooks إذا كان هناك بحث محلي
          final isSearchActive = searchController.text.isNotEmpty;
          final displayBooks = isSearchActive ? filteredBooks : books;

          // إضافة عرض لحالة عدم وجود نتائج بحث
          if (isSearchActive && displayBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "${S.of(context).noSearchResults}\"${searchController.text}\"",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    S.of(context).noSearchResultsDesc,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return HomeProductsGridView(books: displayBooks);
        } else if (state is HomeBooksFailureState) {
          return Center(
            child: Column(
              children: [
                Text(
                  S.of(context).fetchItemsError,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _homeCubit.getHomeBooks(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child:  Text(S.of(context).retry),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.person, color: AppColors.primary),
      title: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.isLoading,
            effect: PulseEffect(
              duration: const Duration(milliseconds: 800),
              from: AppColors.secondary.withValues(alpha: 51),
              to: AppColors.primary.withValues(alpha: 51),
            ),
            child: Text(
              state.isSuccess && state.profile != null
                  ? state.profile!.fullName
                  : S.of(context).tkweenUser,
              style: TextStyle(color: AppColors.text),
            ),
          );
        },
      ),
      centerTitle: false,
      actions: [
        if (!Platform.isIOS) ...[
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () {
              context.showComingSoonFeature();
            },
          ),
          const SizedBox(width: 8),
        ],
      ],
      scrolledUnderElevation: 0,
    );
  }
}
