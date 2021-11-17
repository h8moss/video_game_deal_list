import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/common/services/preferences_deal_server.dart';

import 'app/home_page/home_page_builder.dart';
import 'common/services/api_deal_server.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ApiDealServer>(
      create: (_) => ApiDealServer(),
      dispose: (context, value) => value.dispose(),
      child: Provider<PreferencesDealServer>(
        create: (context) => PreferencesDealServer(
          Provider.of<ApiDealServer>(context, listen: false),
        ),
        dispose: (context, value) => value.dispose(),
        child: MaterialApp(
          title: 'Video Game Deal Viewer',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: HomePageBuilder(),
        ),
      ),
    );
  }
}
