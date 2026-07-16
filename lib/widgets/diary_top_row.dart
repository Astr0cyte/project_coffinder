import 'package:flutter/material.dart';
import 'diary_tab.dart';

class DiaryTopRow extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DiaryTopRow({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: DiaryTab(
              text: tabs[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}