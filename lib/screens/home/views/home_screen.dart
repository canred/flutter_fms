import 'package:flutter/material.dart';
import 'package:test/screens/home/views/components/my_request_list.dart';
import 'package:test/screens/home/views/components/test_form.dart';
import 'package:test/screens/home/views/components/test_table.dart';
import 'package:test/screens/home/views/components/test_fab_monitor.dart';
import 'package:test/screens/home/views/components/test_fab_monitor2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'components/offer_carousel_and_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('audio/level-up-191997.mp3'));

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
            // 這是一個自訂的組件，顯示 Fab Monitor
            SliverToBoxAdapter(child: TestFabMonitor()),
            // SliverToBoxAdapter(child: TestTable2()),
          ],
        ),
      ),
    );
  }
}
