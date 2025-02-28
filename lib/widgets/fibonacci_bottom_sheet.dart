import 'package:flutter/material.dart';

class FibonacciBottomSheet {
  static Future<void> show(
    BuildContext context,
    int tappedValue,
    List<Map<String, dynamic>> movedItems,
    List<Map<String, dynamic>> fibonacciData,
    Map<int, IconData> icons,
    Function setState,
    Function scrollToHighlighted,
    Function highlightRestoredItem, // ✅ ไฮไลต์ไอเทมที่คืนกลับ
  ) {
    IconData selectedIcon = icons[tappedValue % 3]!;

    // ดึงเฉพาะไอเทมที่เป็นประเภทเดียวกันจาก movedItems
    List<Map<String, dynamic>> filteredItems =
        movedItems
            .where((e) => icons[e['number'] % 3] == selectedIcon)
            .toList();

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      clipBehavior: Clip.hardEdge, // ✅ ตัดขอบทุกอย่างให้พอดี
      builder: (context) {
        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            int selectedItem = filteredItems[index]['number'];
            int originalIndex = filteredItems[index]['index'];
            bool isHighlighted = originalIndex == movedItems.last['index'];

            return ListTile(
              tileColor:
                  isHighlighted
                      ? const Color(0xFF4BAE4E)
                      : null, // ✅ BG สีเขียวเต็มแถว
              title: Text(
                'Number: $selectedItem',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: isHighlighted ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                'Index: $originalIndex', // ✅ ใช้ index ดั้งเดิม
                style: TextStyle(
                  color: isHighlighted ? Colors.white70 : Colors.grey[700],
                ),
              ),
              trailing: Icon(
                selectedIcon,
                color: isHighlighted ? Colors.white : null,
              ),
              onTap: () {
                int restoredIndex = filteredItems[index]["index"];

                int insertPosition = fibonacciData.indexWhere(
                  (item) => item["index"] > restoredIndex,
                );

                if (insertPosition == -1) {
                  insertPosition = fibonacciData.length;
                }

                restoredIndex = insertPosition;

                setState(() {
                  movedItems.remove(
                    filteredItems[index],
                  ); // ✅ เอาออกจาก Bottom Sheet
                  fibonacciData.insert(
                    restoredIndex,
                    filteredItems[index],
                  ); // ✅ คืนค่ากลับไปตำแหน่งเดิม
                });
                Navigator.of(context).pop();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  highlightRestoredItem(
                    filteredItems[index]["index"],
                    Colors.red,
                  );
                  Future.delayed(const Duration(milliseconds: 300), () {
                    scrollToHighlighted();
                  });
                });
              },
            );
          },
        );
      },
    );
  }
}
