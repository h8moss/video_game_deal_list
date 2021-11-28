import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/common/services/ad_id_provider.dart';
import 'package:video_game_wish_list/common/widgets/price_tag.dart';
import 'package:video_game_wish_list/common/widgets/store_display_builder.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';

/// Display for a selected deal
class DealPage extends StatefulWidget {
  const DealPage({
    Key? key,
    required this.model,
    required this.isFavorite,
    required this.onBookmarkPressed,
  }) : super(key: key);

  final DealModel model;
  final bool isFavorite;
  final VoidCallback? onBookmarkPressed;

  @override
  State<DealPage> createState() => _DealPageState();
}

class _DealPageState extends State<DealPage> {
  final BannerAd banner = BannerAd(
    adUnitId: AdIDProvider.dealPageBannerID,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    banner.load();

    super.initState();
  }

  @override
  void dispose() {
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.gameName),
        actions: [
          TextButton(
              onPressed: widget.onBookmarkPressed,
              child: Icon(
                widget.isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                color: Colors.black,
                semanticLabel: widget.isFavorite ? 'Unsave deal' : 'Save deal',
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                            child: Image.network(
                              widget.model.thumbnailUrl,
                              semanticLabel: 'Game image',
                            ),
                            fit: BoxFit.fitWidth),
                      ),
                      Semantics(
                        label: _buildDescription(),
                        child: ExcludeSemantics(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  PriceTag.red(widget.model.originalPrice),
                                  PriceTag.green(widget.model.price),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildBasicText(widget.model.gameName),
                              ),
                              Center(
                                  child: Text(
                                'is',
                                style: TextStyle(color: Colors.black38),
                              )),
                              _buildBasicText(
                                '${widget.model.formattedPercentageOff}% off!',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        'at',
                        style: TextStyle(color: Colors.black38),
                      )),
                      Center(
                          child: StoreDisplayBuilder(
                        storeID: widget.model.storeId,
                        width: 50,
                      )),
                      if (widget.model.hasBetterDeal)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _launchBetterDeal(context),
                            child: Text('We might have found a better deal!'),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () => _launchDeal(context),
                          child: Text(
                            'Open deal',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ExcludeSemantics(child: AdWidget(ad: banner)),
            width: banner.size.width.toDouble(),
            height: banner.size.height.toDouble(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicText(String label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _launchDeal(BuildContext context) async {
    String url =
        'https://www.cheapshark.com/redirect?dealID=${widget.model.id}';

    if (await canLaunch(url)) {
      launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong opening deal')));
    }
  }

  void _launchBetterDeal(BuildContext context) {
    DealPageBuilder.show(context, widget.model.cheapestDeal!);
  }

  String _buildDescription() {
    return '${widget.model.gameName} is ${widget.model.formattedPercentageOff}% off (from ${widget.model.originalPrice}\$ to ${widget.model.price}\$)';
  }
}
