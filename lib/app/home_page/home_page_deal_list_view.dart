import 'package:flutter/material.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/app/deals/deal_tile.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/common/widgets/centered_message.dart';

class HomePageDealListView extends StatelessWidget {
  HomePageDealListView({
    required this.deals,
    required this.hasError,
    required this.isDone,
    required this.onRenderCell,
    required this.onRetryAppending,
    required this.onRetryLoading,
  });

  final List<DealModel>? deals;
  final bool hasError;

  final bool isDone;

  final VoidCallback? onRetryLoading;
  final VoidCallback? onRetryAppending;
  final ValueChanged<int>? onRenderCell;

  int get dealCount => deals?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    if (hasError && dealCount == 0) return _buildErrorMessage();
    if (dealCount != 0)
      return _buildListView();
    else if (deals != null)
      return _buildEmptyPage();
    else
      return Center(child: CircularProgressIndicator());
  }

  Widget _buildListView() {
    return ListView.separated(
        separatorBuilder: (_, __) => Divider(),
        itemCount: dealCount + (!isDone || hasError ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == dealCount) {
            if (hasError)
              return Row(
                children: [
                  TextButton(
                    onPressed: onRetryAppending,
                    child: Icon(Icons.replay),
                  ),
                  Text('Something went wrong loading the deals'),
                ],
              );
            else
              return Center(child: CircularProgressIndicator());
          }
          if (onRenderCell != null) onRenderCell!(index);
          return _buildGridItem(context, deals![index]);
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
        TextButton(onPressed: () => onRetryLoading, child: Icon(Icons.replay)),
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
}
