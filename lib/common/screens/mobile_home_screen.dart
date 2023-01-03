import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/common/screens/search_screen.dart';
import 'package:share_picture/common/screens/user_screen.dart';
import 'package:share_picture/utils/constants.dart';
import '../../post/screens/add_post_screen.dart';
import '../../post/screens/feed_screen.dart';

class MobileHomeScreen extends StatefulWidget {
  static const mobileHomeScreen = '/mobileHomeScreen';
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int bottomNavTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  _onTabChanged(index) {
    bottomNavTabIndex = index.toInt();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: IndexedStack(
        index: bottomNavTabIndex,
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          ProfileScreen(
            userId: Provider.of<AuthProvider>(context, listen: false).user!.uid,
          )
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: _onTabChanged,
        selectedFontSize: 18,
        currentIndex: bottomNavTabIndex,
        backgroundColor: mobileBackgroundColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_rounded,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '',
          ),
        ]);
  }
}
