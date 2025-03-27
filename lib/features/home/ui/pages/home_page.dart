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

//   void filterBooks(String query, List<BookModel> allBooks) {
//     if (query.isEmpty) {
//       setState(() => filteredBooks = []);
//       return;
//     }

//     final tempBooks =
//         allBooks
//             .where(
//               (book) =>
//                   book.title.toLowerCase().contains(query.toLowerCase()) ||
//                   book
//                       .getLocalizedCategory(context)
//                       .toLowerCase()
//                       .contains(query.toLowerCase()),
//             )
//             .toList();

//     setState(() => filteredBooks = tempBooks);
//   }

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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';
import 'package:united_formation_app/features/home/ui/cubit/home_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_state.dart';
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

  void filterBooks(String query, List<BookModel> allBooks) {
    if (query.isEmpty) {
      setState(() => filteredBooks = []);
      return;
    }

    final tempBooks =
        allBooks
            .where(
              (book) =>
                  book.title.toLowerCase().contains(query.toLowerCase()) ||
                  book
                      .getLocalizedCategory(context)
                      .toLowerCase()
                      .contains(query.toLowerCase()),
            )
            .toList();

    setState(() => filteredBooks = tempBooks);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مطلوب للـ AutomaticKeepAliveClientMixin

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

  Widget _buildSearchField() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return TextFormField(
          controller: searchController,
          onChanged: (query) => filterBooks(query, _homeCubit.books),
          cursorColor: AppColors.primary,
          cursorWidth: 1.5,
          cursorRadius: const Radius.circular(2),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
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
                  "خطأ في تحميل الفئات، يرجى المحاولة مرة أخرى",
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _homeCubit.getBooksCategories(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text("إعادة المحاولة"),
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

  Widget _buildPopularHeader() {
    return const Text(
      "Popular",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

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
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is HomeBooksSuccessState) {
          final books = state.books;

          if (books.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد كتب في هذه الفئة",
                style: TextStyle(color: Colors.black87),
              ),
            );
          }

          // استخدام filteredBooks إذا كان هناك بحث محلي
          final displayBooks =
              filteredBooks.isNotEmpty && searchController.text.isNotEmpty
                  ? filteredBooks
                  : books;

          return HomeProductsGridView(books: displayBooks);
        } else if (state is HomeBooksFailureState) {
          return Center(
            child: Column(
              children: [
                const Text(
                  "خطأ، يرجى المحاولة مرة أخرى",
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _homeCubit.getHomeBooks(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.primary),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text("إعادة المحاولة"),
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
          if (state.isSuccess && state.profile != null) {
            // عرض اسم المستخدم إذا كان متاحاً
            return Text(
              state.profile!.fullName,
              style: TextStyle(color: AppColors.text),
            );
          } else {
            // عرض اسم افتراضي إذا لم يكن الاسم متاحاً بعد
            return Text(
              'مستخدم تكوين',
              style: TextStyle(color: AppColors.text),
            );
          }
        },
      ),
      centerTitle: false,
      actions: [
        if (Theme.of(context).platform != TargetPlatform.iOS)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.notifications_none,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        const SizedBox(width: 10),
      ],
      scrolledUnderElevation: 0,
    );
  }
}
