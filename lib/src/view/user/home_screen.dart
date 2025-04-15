import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
//import 'package:quizy/src/theme/app_theme.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/profile/profile_page.dart';
import 'package:quizy/src/view/user/widgets/build_category_card.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Assuming AppTheme is defined in your project

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<String> _categoryfilters = ['All'];
  String _selectedFilter = 'All';
  bool _fetching = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('categories')
            .orderBy('createdAt', descending: true)
            .get();

    setState(() {
      _allCategories =
          snapshot.docs
              .map((doc) => Category.fromMap(doc.id, doc.data()))
              .toList();
      _fetching = false;

      _categoryfilters =
          ['All'] + _allCategories.map((category) => category.name).toList();

      _filteredCategories = _allCategories;
    });
  }

  void _filterCategories(String query, {String? categoryfilter}) {
    setState(() {
      _filteredCategories =
          _allCategories.where((category) {
            final matchedSearch =
                category.name.toLowerCase().contains(query.toLowerCase()) ||
                category.description.toLowerCase().contains(
                  query.toLowerCase(),
                );

            final matchesCategory =
                categoryfilter == null ||
                categoryfilter == 'All' ||
                category.name.toLowerCase() == categoryfilter.toLowerCase();

            return matchedSearch && matchesCategory;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        body: Skeletonizer(
          enabled: _fetching,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    icon: Icon(Icons.account_circle, size: 45),
                  ),
                ],
                automaticallyImplyLeading: false,
                expandedHeight: 238,
                pinned: true,
                floating: true,
                centerTitle: false,
                backgroundColor: AppTheme.primaryColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                title: const Text(
                  "Smart Quiz",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome, Learner",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Let's Test Your knowledge today",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged:
                                      (value) => _filterCategories(value),
                                  decoration: InputDecoration(
                                    hintText: "Search category",
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppTheme.primaryColor,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterCategories('');
                                      },
                                      icon: Icon(Icons.clear),
                                      color: AppTheme.primaryColor,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  collapseMode: CollapseMode.pin,
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(16),
                  height: 40,
                  child: ListView.builder(
                    itemCount: _categoryfilters.length,
                    itemBuilder: (context, index) {
                      final filter = _categoryfilters[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          backgroundColor: Colors.white,
                          label: Text(
                            filter,
                            style: TextStyle(
                              color:
                                  _selectedFilter == filter
                                      ? Colors.white
                                      : AppTheme.textPrimaryColor,
                            ),
                          ),
                          selected: _selectedFilter == filter,
                          onSelected: (value) {
                            setState(() {
                              _selectedFilter = filter;
                              _filterCategories(
                                _searchController.text,
                                categoryfilter: filter,
                              );
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver:
                    _filteredCategories.isEmpty
                        ? SliverToBoxAdapter(
                          child: Text(
                            "No categories found",
                            style: TextStyle(color: AppTheme.secondaryColor),
                          ),
                        )
                        : SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            childCount: _filteredCategories.length,
                            (context, index) => BuildCategoryCard(
                              category: _filteredCategories[index],
                              index: index,
                            ),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
