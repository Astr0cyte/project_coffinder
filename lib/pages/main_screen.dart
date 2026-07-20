// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'diary_page.dart';
// import 'add_cafe/step1_picture_page.dart';
// import 'profile_page.dart';
// import '../states/add_cafe_state.dart';
// import '../widgets/custom_floating_navbar.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//   bool _navVisible = true;
//   double _lastOffset = 0;
//
//   final AddCafeState _addCafeState = AddCafeState();
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     // Danh sách 4 trang tương ứng với 4 nút trên Navbar
//     _pages = [
//       const HomeScreen(),                      // Index 0
//       const DiaryPage(),                       // Index 1
//       Step1PicturePage(state: _addCafeState),  // Index 2
//       ProfilePage(),                     // Index 3
//     ];
//   }
//
//   bool _handleScroll(ScrollNotification notification) {
//     final offset = notification.metrics.pixels;
//     final max = notification.metrics.maxScrollExtent;
//     final delta = offset - _lastOffset;
//     if (offset <= 0 || offset >= max) {
//       if (!_navVisible) setState(() => _navVisible = true);
//     } else if (delta > 6 && _navVisible) {
//       setState(() => _navVisible = false);
//     } else if (delta < -6 && !_navVisible) {
//       setState(() => _navVisible = true);
//     }
//     _lastOffset = offset;
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       backgroundColor: const Color(0xFFFAF9F4),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: _handleScroll,
//         child: IndexedStack(
//           index: _currentIndex,
//           children: _pages,
//         ),
//       ),
//       bottomNavigationBar: CustomFloatingNavBar(
//         isVisible: _navVisible,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             _navVisible = true;
//           });
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'diary_page.dart';
import 'add_cafe/step1_picture_page.dart';
import 'profile_page.dart';
import '../states/add_cafe_state.dart';
import '../widgets/custom_floating_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _navVisible = true;
  double _lastOffset = 0;

  final AddCafeState _addCafeState = AddCafeState();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Danh sách 4 trang tương ứng với 4 nút trên Navbar
    _pages = [

      const HomeScreen(),                      // Index 0
      const DiaryPage(),                       // Index 1
      Step1PicturePage(state: _addCafeState),  // Index 2
      ProfilePage(),                           // Index 3
    ];
  }

  bool _handleScroll(ScrollNotification notification) {
    final offset = notification.metrics.pixels;
    final max = notification.metrics.maxScrollExtent;
    final delta = offset - _lastOffset;
    if (offset <= 0 || offset >= max) {
      if (!_navVisible) setState(() => _navVisible = true);
    } else if (delta > 6 && _navVisible) {
      setState(() => _navVisible = false);
    } else if (delta < -6 && !_navVisible) {
      setState(() => _navVisible = true);
    }
    _lastOffset = offset;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFFAF9F4),
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        // Đã sửa: Thay IndexedStack bằng việc gọi trực tiếp trang theo _currentIndex
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        isVisible: _navVisible,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _navVisible = true;
          });
        },
      ),
    );
  }
}