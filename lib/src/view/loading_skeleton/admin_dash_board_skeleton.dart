import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/loading_skeleton/listtile_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdminDashBoardSkeleton extends StatelessWidget {
  const AdminDashBoardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(height: 20, width: 240, color: AppTheme.skeletonColor),
      ),
      body: Skeleton.shade(
        shade: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                height: 30,
                width: width - 25,
                color: AppTheme.skeletonColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.skeletonColor.withAlpha(100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              height: 25,
                              width: 25,
                              color: AppTheme.skeletonColor,
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            height: 20,
                            width: 50,
                            color: AppTheme.skeletonColor,
                          ),
                          SizedBox(height: 24),
                          Container(
                            height: 14,
                            width: 30,
                            color: AppTheme.skeletonColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.skeletonColor.withAlpha(100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              height: 25,
                              width: 25,
                              color: AppTheme.skeletonColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 20,
                            width: 50,
                            color: AppTheme.skeletonColor,
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 14,
                            width: 30,
                            color: AppTheme.skeletonColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListtileSkeleton(),
            SizedBox(height: 15),
            ListtileSkeleton(),
            SizedBox(height: 15),

            Expanded(child: ListtileSkeleton()),
          ],
        ),
      ),
    );
  }
}
