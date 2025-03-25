import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';

class CategoriesPopupMenu extends StatelessWidget {
  const CategoriesPopupMenu({super.key, required this.onSelected});
  final void Function(dynamic value)? onSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'edit',
            child: ListTile(
              title: Text("Edit"),
              leading: Icon(Icons.edit, color: AppTheme.primaryColor),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: ListTile(
              title: Text("Delete"),
              leading: Icon(Icons.delete, color: Colors.red),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ];
      },

      onSelected: onSelected,
    );
  }
}
