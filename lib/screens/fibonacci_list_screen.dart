// lib/screens/fibonacci_list_screen.dart
import 'package:flutter/material.dart';
import '../utils/fibonacci_utils.dart';
import '../widgets/fibonacci_bottom_sheet.dart';
import '../widgets/fibonacci_list_tile.dart';
import '../widgets/adaptive_scaffold.dart';

class FibonacciListScreen extends StatefulWidget {
  final TargetPlatform platform;

  const FibonacciListScreen({super.key, required this.platform});

  @override
  State<FibonacciListScreen> createState() => _FibonacciListScreenState();
}

class _FibonacciListScreenState extends State<FibonacciListScreen> {
  late List<Map<String, dynamic>> _fibonacciData;
  final List<Map<String, dynamic>> _movedItems = [];
  final Map<int, IconData> _icons = {
    0: Icons.circle,
    1: Icons.crop_square,
    2: Icons.close,
  };
  int? _highlightedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeFibonacciList();
  }

  void _initializeFibonacciList() {
    List<int> fibonacciNumbers = FibonacciUtils.generateFibonacci(41);
    _fibonacciData = List.generate(fibonacciNumbers.length, (index) {
      return {"index": index, "number": fibonacciNumbers[index]};
    });
  }

  void _scrollToHighlighted() {
    if (_highlightedIndex != null) {
      _scrollController.animateTo(
        _highlightedIndex! * 60.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _highlightRestoredItem(int index) {
    setState(() {
      _highlightedIndex = _fibonacciData.indexWhere(
        (item) => item["index"] == index,
      );
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _highlightedIndex = null; // ลบไฮไลต์หลัง 2 วินาที
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Fibonacci List',
      child: Scrollbar(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _fibonacciData.length,
          itemBuilder: (context, index) {
            int number = _fibonacciData[index]["number"];
            int originalIndex = _fibonacciData[index]["index"];
            int type = number % 3;
            IconData icon = _icons[type]!;
            bool isSameType =
                !_movedItems.any((item) => item["index"] == originalIndex);

            return FibonacciListTile(
              number: number,
              index: originalIndex, // ✅ ใช้ index ดั้งเดิม
              icon: icon,
              isHighlighted: index == _highlightedIndex,
              isSameType: isSameType,
              onTap: () {
                setState(() {
                  _movedItems.add(
                    _fibonacciData[index],
                  ); // ✅ ย้ายไอเทมไป BottomSheet
                  _fibonacciData.removeAt(index); // ✅ ลบออกจากลิสต์หลัก
                });

                FibonacciBottomSheet.show(
                  context,
                  number,
                  _movedItems,
                  _fibonacciData,
                  _icons,
                  setState,
                  () => _highlightedIndex = 0,
                  _scrollToHighlighted,
                  _highlightRestoredItem, // ✅ ไฮไลต์ไอเทมที่คืนกลับ
                ).whenComplete(() {
                  setState(() {
                    _highlightedIndex = null;
                  });
                });
              },
            );
          },
        ),
      ),
    );
  }
}
