import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/app/deals/deal_tile.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/common/services/ad_id_provider.dart';
import 'package:video_game_wish_list/common/widgets/centered_message.dart';

class HomePageDealListView extends StatefulWidget {
  HomePageDealListView({
    required this.deals,
    required this.hasError,
    required this.isDone,
    required this.onRenderCell,
    required this.onRetryAppending,
    required this.onRetryLoading,
    required this.kAdCount,
  });

  final List<DealModel>? deals;
  final bool hasError;

  final bool isDone;

  final VoidCallback? onRetryLoading;
  final VoidCallback? onRetryAppending;

  final ValueChanged<int>? onRenderCell;

  /// Number of actual items on the list between ads, -1 means no ads
  final int kAdCount;

  @override
  State<HomePageDealListView> createState() => _HomePageDealListViewState();
}

class _HomePageDealListViewState extends State<HomePageDealListView> {
  bool get showAds => widget.kAdCount > 0;

  int get dealCount => widget.deals?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    if (widget.hasError && dealCount == 0) return _buildErrorMessage();
    if (dealCount != 0)
      return _buildListView();
    else if (widget.deals != null)
      return _buildEmptyPage();
    else
      return Center(child: CircularProgressIndicator());
  }

  Widget _buildListView() {
    return ListView.separated(
        separatorBuilder: (_, __) => Divider(),
        itemCount: _getItemCount(),
        itemBuilder: (context, index) {
          if (index == dealCount) {
            if (widget.hasError)
              return Row(
                children: [
                  TextButton(
                    onPressed: widget.onRetryAppending,
                    child: Icon(Icons.replay),
                  ),
                  Text('Something went wrong loading the deals'),
                ],
              );
            else
              return Center(child: CircularProgressIndicator());
          }
          if (widget.onRenderCell != null) widget.onRenderCell!(index);
          if ((index + 1) % widget.kAdCount == 0 && showAds) {
            return _buildAd();
          }
          return _buildGridItem(context, widget.deals![_getIndex(index)]);
        });
  }

  Widget _buildErrorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CenteredMessage(
          message: 'Something went wrong.',
          secondaryMessage: 'Please try again later',
        ),
        TextButton(
            onPressed: () => widget.onRetryLoading, child: Icon(Icons.replay)),
      ],
    );
  }

  Widget _buildEmptyPage() {
    return CenteredMessage(
      message: 'Nothing here...',
      secondaryMessage: 'Except for you and me :)',
    );
  }

  Widget _buildGridItem(BuildContext context, DealModel model) {
    return Center(
      child: DealTile(
        onPressed: () => DealPageBuilder.show(context, model.id),
        saleModel: model,
      ),
    );
  }

  Widget _buildAd() {
    BannerAd ad = BannerAd(
      adUnitId: AdIDProvider.listviewBannerID,
      listener: BannerAdListener(),
      request: AdRequest(),
      size: AdSize.banner,
    );

    return FutureBuilder<void>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        if (snapshot.hasError) return Container();
        return SizedBox(
          child: AdWidget(ad: ad),
          height: ad.size.height.toDouble(),
          width: ad.size.width.toDouble(),
        );
      },
      future: ad.load(),
    );
  }

  int _getIndex(int rawIndex) {
    return rawIndex - (rawIndex / widget.kAdCount).floor();
  }

  int _getItemCount() {
    int rawCount = dealCount + (!widget.isDone || widget.hasError ? 1 : 0);
    print(rawCount + (rawCount / widget.kAdCount).floor());
    return rawCount + (rawCount / widget.kAdCount).floor();
  }
}
