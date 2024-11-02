import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/components/dot_indicators.dart';
import 'package:test/constants.dart';
import 'package:test/route/route_constants.dart';
import 'components/onbording_content.dart';

// 引導畫面的內容資料
class Onbord {
  final String image, title, description;
  final String? imageDarkTheme;

  Onbord({
    required this.image,
    required this.title,
    this.description = "",
    this.imageDarkTheme,
  });
}

// 系統的畫面的主要入口點
// StatefulWidget 是一個特殊的小部件，它有一個可變的狀態。
class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  /// 用於 PageView 的控制器，允許以程式方式控制頁面的位置。
  /// 這用於管理引導畫面的狀態和行為，實現不同頁面之間的導航。
  /// `_pageController` 被初始化為 late 變數，這意味著它會在使用前被賦值。
  late PageController _pageController;
  // 記錄是第幾個頁面
  late int _pageIndex = 0;
  // 引導畫面的內容資料
  final List<Onbord> _onbordData = [
    // 以下是要顯示的內容頁面資料
    Onbord(
      image: "assets/images/ic_design_01.jpeg",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_0.png",
      title: "Find the item you’ve \nbeen looking for",
      description: "Here you’ll see rich varieties of goods, carefully classified for seamless browsing experience.",
    ),
    // Onbord(
    //   image: "assets/Illustration/Illustration-1.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
    //   title: "About Us \n",
    //   description:
    //       "The company aims for sustainable development, emphasizing environmental, social and corporate governance responsibility. It values employees' work-life balance and potential development, and pursues excellence in technology and service.",
    // ),
    // ...
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              // Align 是一個小部件，用於將子小部件對齊到指定的位置。
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // 跳轉到登入畫面
                    Navigator.pushNamed(context, logInScreenRoute);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ),
              ),
              // Expanded 是一個小部件，用於將子小部件擴展以填充可用空間。
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onbordData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _pageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) => OnbordingContent(
                    title: _onbordData[index].title,
                    description: _onbordData[index].description,
                    image: (Theme.of(context).brightness == Brightness.dark && _onbordData[index].imageDarkTheme != null) ? _onbordData[index].imageDarkTheme! : _onbordData[index].image,
                    isTextOnTop: index.isOdd,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onbordData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  // Spacer 是一個小部件，用於在子小部件之間添加空間。
                  const Spacer(),
                  // SizedBox 是一個小部件，用於在子小部件周圍添加空間。
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // 如果不是最後一個頁面，則跳轉到下一個頁面
                        if (_pageIndex < _onbordData.length - 1) {
                          _pageController.nextPage(curve: Curves.ease, duration: defaultDuration);
                        } else {
                          // 如果是最後一個頁面，則跳轉到登入畫面
                          Navigator.pushNamed(context, logInScreenRoute);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
