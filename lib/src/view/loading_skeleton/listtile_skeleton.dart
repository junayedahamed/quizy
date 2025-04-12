import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListtileSkeleton extends StatelessWidget {
  const ListtileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(duration: Duration(seconds: 1)),
      child: Card(
        elevation: 5,

        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Container(width: 180, color: Colors.grey, height: 25),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Container(height: 20, width: 80, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
