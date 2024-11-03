import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/constants.dart';
import 'package:test/route/screen_export.dart';
import 'package:test/main.dart';

// 完成 Microsoft Entra ID 的登入後，將使用者導向應用程式的入口點
class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // 這裡定義了應用程式的各個頁面
  // 使用在底部導覽列中
  final List _pages = const [
    // 這是收首頁的畫面
    HomeScreen(),
    // DiscoverScreen(),
    // BookmarkScreen(),
    // EmptyCartScreen(), // if Cart is empty
    // CartScreen(),
    // 使用者的個人資料畫面
    ProfileScreen(),
  ];
  // 這是目前所選擇的頁面
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(color ?? Theme.of(context).iconTheme.color!.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 1), BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Image.asset(
          "assets/logo/vislogo.png",
          height: 35,
          width: 70,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0), // 設定 padding-top 為 8.0
              child: Image.asset("assets/icons/notification-bell.png", height: 24),
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex], // 先留下來，之後會用到
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              // icon: svgIcon("assets/icons/Shop.svg"),
              // activeIcon: svgIcon("assets/icons/.svg", color: primaryColor),
              icon: Image.asset("assets/images/home.png", height: 24),
              activeIcon: Image.asset("assets/images/home.png", height: 24, color: primaryColor),
              label: "Main",
            ),
            // BottomNavigationBarItem(
            //   icon: svgIcon("assets/icons/Category.svg"),
            //   activeIcon: svgIcon("assets/icons/Category.svg", color: primaryColor),
            //   label: "Discover",
            // ),
            // BottomNavigationBarItem(
            //   icon: svgIcon("assets/icons/Bookmark.svg"),
            //   activeIcon: svgIcon("assets/icons/Bookmark.svg", color: primaryColor),
            //   label: "Bookmark",
            // ),
            // BottomNavigationBarItem(
            //   icon: svgIcon("assets/icons/Bag.svg"),
            //   activeIcon: svgIcon("assets/icons/Bag.svg", color: primaryColor),
            //   label: "Cart",
            // ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon: svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
