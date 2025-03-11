import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/home/data/product_model.dart';
import '../widgets/home_products_grid_view.dart';
import '../widgets/home_widgets/categories_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [
    ProductModel(
      id: '1',
      dateTime: DateTime.now().toString(),
      category: 'Fiction',
      brand: 'Penguin Books',
      description: 'A thrilling mystery novel full of unexpected twists.',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=1000',
      name: 'The Silent Patient',
      price: 250.0,
      offer: false,
    ),
    // ProductModel(
    //   id: '2',
    //   dateTime: DateTime.now().toString(),
    //   category: 'Science Fiction',
    //   brand: 'HarperCollins',
    //   description: 'A fascinating journey through space and time.',
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1518744946-39d48f3b2464?q=80&w=1000',
    //   name: 'Dune',
    //   price: 300.0,
    //   offer: true,
    // ),
    ProductModel(
      id: '3',
      dateTime: DateTime.now().toString(),
      category: 'Self-Help',
      brand: 'Simon & Schuster',
      description: 'A guide to building good habits and breaking bad ones.',
      imageUrl:
          'https://images.unsplash.com/photo-1531988042231-d39a9cc12a9a?q=80&w=1000',
      name: 'Atomic Habits',
      price: 200.0,
      offer: false,
    ),
    ProductModel(
      id: '4',
      dateTime: DateTime.now().toString(),
      category: 'Biography',
      brand: 'Macmillan Publishers',
      description:
          'The inspiring life story of one of the greatest minds in history.',
      imageUrl:
          'https://images.unsplash.com/photo-1541963463532-d68292c34b19?q=80&w=1000',
      name: 'Steve Jobs',
      price: 350.0,
      offer: true,
    ),
    ProductModel(
      id: '5',
      dateTime: DateTime.now().toString(),
      category: 'Fantasy',
      brand: 'Bloomsbury',
      description: 'The first book in the legendary Harry Potter series.',
      imageUrl:
          'https://images.unsplash.com/photo-1629992101753-56d196c8aabb?q=80&w=1000',
      name: 'Harry Potter and the Sorcerer\'s Stone',
      price: 280.0,
      offer: false,
    ),
    ProductModel(
      id: '6',
      dateTime: DateTime.now().toString(),
      category: 'History',
      brand: 'Oxford University Press',
      description: 'A detailed account of World War II from start to finish.',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=1000',
      name: 'The Second World War',
      price: 400.0,
      offer: true,
    ),
    ProductModel(
      id: '7',
      dateTime: DateTime.now().toString(),
      category: 'Psychology',
      brand: 'Random House',
      description:
          'Exploring the power of human thinking and its impact on decision making.',
      imageUrl:
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=1000',
      name: 'Thinking, Fast and Slow',
      price: 270.0,
      offer: false,
    ),
    ProductModel(
      id: '8',
      dateTime: DateTime.now().toString(),
      category: 'Business',
      brand: 'Harvard Business Review Press',
      description: 'How to develop a mindset that leads to success.',
      imageUrl:
          'https://images.unsplash.com/photo-1589998059171-988d887df646?q=80&w=1000',
      name: 'The Lean Startup',
      price: 320.0,
      offer: true,
    ),
  ];

  List<ProductCategoryOrBrandModel> categories = [
    ProductCategoryOrBrandModel(id: '1', name: 'All'),
    ProductCategoryOrBrandModel(id: '2', name: 'Men'),
    ProductCategoryOrBrandModel(id: '3', name: 'Women'),
    ProductCategoryOrBrandModel(id: '4', name: 'Kids'),
    ProductCategoryOrBrandModel(id: '4', name: 'Men'),
    ProductCategoryOrBrandModel(id: '4', name: 'Women'),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    fillColor: AppColors.inputBackgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CategoriesListView(categoryItems: categories),
                const SizedBox(height: 20),
                Text(
                  "Popular",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                HomeProductsGridView(products: products),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      leading: Icon(Icons.person, color: Colors.white),
      title: Text('M7m7', style: TextStyle(color: Colors.white)),
      centerTitle: false,
      actions: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkSecondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ),
        SizedBox(width: 10),
      ],
      scrolledUnderElevation: 0,
    );
  }
}
