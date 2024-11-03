import 'package:flutter/material.dart';
import 'package:test/screens/home/views/components/my_request_list.dart';
import 'package:test/screens/home/views/components/test_form.dart';
import 'package:test/screens/home/views/components/test_table.dart';
import 'package:audioplayers/audioplayers.dart';
import 'components/offer_carousel_and_categories.dart';
// import 'package:test/components/Banner/S/banner_s_style_1.dart';
// import 'package:test/components/Banner/S/banner_s_style_5.dart';
// import 'package:test/constants.dart';
// import 'package:test/route/screen_export.dart';
// import 'components/best_sellers.dart';
// import 'components/flash_sale.dart';
// import 'components/most_popular.dart';
// import 'components/popular_products.dart';
// import 'package:test/main.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('audio/login_success.mp3'));

    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 這是一 圖片輪播+系統清單 的組件
            SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            // 這是一個自訂的分類選單，顯示 我的簽核單
            SliverToBoxAdapter(child: MyRequestList()),
            // 這是一個自訂的表單，顯示 表單元件
            SliverToBoxAdapter(child: TestForm()),
            // 這是一個自訂的表格，顯示 表格元件
            SliverToBoxAdapter(child: TestTable()),
            // SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
