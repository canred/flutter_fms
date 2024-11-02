import 'package:flutter/material.dart';
// import 'package:test/components/Banner/S/banner_s_style_1.dart';
// import 'package:test/components/Banner/S/banner_s_style_5.dart';
// import 'package:test/constants.dart';
// import 'package:test/route/screen_export.dart';
import 'package:test/screens/home/views/components/my_request_list.dart';
import 'package:test/screens/home/views/components/test_form.dart';
import 'package:test/screens/home/views/components/test_table.dart';

import 'components/best_sellers.dart';
// import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
// import 'components/popular_products.dart';
import 'package:test/main.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';

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
            SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(child: MyRequestList()),
            SliverToBoxAdapter(child: TestForm()),
            SliverToBoxAdapter(child: TestTable()),
            // SliverToBoxAdapter(child: BestSellers()),
          ],
        ),
      ),
    );
  }
}
