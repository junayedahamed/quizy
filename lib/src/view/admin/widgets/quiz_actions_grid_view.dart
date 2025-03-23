import 'package:flutter/material.dart';
import 'package:quizy/src/view/admin/widgets/dash_board_card.dart';

class QuizActionGridview extends StatelessWidget {
  const QuizActionGridview({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      crossAxisSpacing: 16,

      children: [
        DashBoardCard(
          title: 'Create Quiz',
          ontap: () {},
          icon: Icons.add_rounded,
        ),
        DashBoardCard(
          title: 'Manage Quizes',
          ontap: () {},
          icon: Icons.quiz_rounded,
        ),
        DashBoardCard(
          title: 'Manage Categories',
          ontap: () {},
          icon: Icons.category_rounded,
        ),
      ],
    );
  }
}
