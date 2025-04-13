import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchCategoroes();
  }

  Future<void> _fetchCategoroes() async {
    final snapshpot =
        await FirebaseFirestore.instance
            .collection('categories')
            .orderBy('createdAt', descending: true)
            .get();
    setState(() {
      _allCategories =
          snapshpot.docs
              .map((doc) => Category.fromMap(doc.id, doc.data()))
              .toList();

      _categoryfilters =
          ['All'] + _allCategories.map((category) => category.name).toList();

      _filteredCategories = _allCategories;
    });
  }

  void _filteredCategory(String query, {String? categoryfilter}) {
    setState(() {
      _filteredCategories =
          _allCategories.where((categry) {
            final matchedSearch =
                categry.name.toLowerCase().contains(query.toLowerCase()) ||
                categry.description.toLowerCase().contains(query.toLowerCase());

            final matchesCategory =
                categoryfilter == null ||
                categoryfilter == 'All' ||
                categry.name.toLowerCase() == categoryfilter.toLowerCase();
            return matchedSearch && matchesCategory;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
