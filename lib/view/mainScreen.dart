import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/utils/app_colors..dart';
import 'package:instagram/view/search_screen.dart';
import 'package:provider/provider.dart';

import '../provider/userProvider.dart';
import 'FeedScreen.dart';
import 'post_Screen.dart';
import 'user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController();
  int curentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();

    _pageController = PageController();
  }

  void addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  void navigatedTap(int page) {
    _pageController.jumpToPage(page);
  }

  int _page = 0;

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
 Future<bool> _onWillPop() async {
    if (curentPage == 0) {
      // If the current page is the home page, exit the app
      return true; // Allow app exit
    } else {
      // Navigate to the previous page
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return false; // Prevent app exit
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.mobileBackgroundColor,
          onTap: navigatedTap,
          currentIndex: curentPage,
          items: [
            BottomNavigationBarItem(
              label: 'home',
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: 'search',
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: 'add post',
              icon: Icon(
                Icons.add_circle_rounded,
                color: _page == 2
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: 'profile',
              icon: Icon(
                Icons.person,
                color: _page == 3
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: pageChanged,
          children: [
            const FeedScreen(),
            const SearchScreen(),
            const PostScreen(),
            UserProfileScreen(uuid: FirebaseAuth.instance.currentUser!.uid),
          ],
        ),
      ),
    );
  }
}
