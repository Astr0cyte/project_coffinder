
import 'package:brewstreet_app/pages/add_cafe/step1_picture_page.dart';
import 'package:brewstreet_app/pages/diary_pages/diary_page.dart';
import 'package:brewstreet_app/pages/home_screen.dart';
import 'package:brewstreet_app/pages/profile_page.dart';
import 'package:brewstreet_app/states/add_cafe_state.dart';
import 'package:flutter/material.dart';
import 'package:brewstreet_app/pages/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.context,
    required this.navVisible,
  });

  final BuildContext context;
  final bool navVisible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: navVisible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: navVisible ? Offset.zero : const Offset(0, 1.6),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: navVisible ? 1 : 0,
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.brownDark,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                      _navIcon(Icons.home, active: true, onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      }),
                      _navIcon(Icons.bookmark_border, onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => DiaryPage()),
                        );
                      }),
                      _navIcon(Icons.history, onTap: () {}),
                      _navIcon(Icons.add, onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Step1PicturePage(state: AddCafeState())),
                      )),
                      _navIcon(Icons.person_outline, onTap: () {Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ProfilePage()),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, {bool active = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.tan : Colors.transparent,
      ),
      child: Icon(
        icon,
        size: 20,
        color: active ? AppColors.brownDark : AppColors.tan.withOpacity(0.6),
      ),
      ),
    );
  }
}