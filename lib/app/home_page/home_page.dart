import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/app/deals/deal_tile.dart';
import 'package:video_game_wish_list/app/home_page/home_page_bloc.dart';
import 'package:video_game_wish_list/app/home_page/home_page_event.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/common/services/game_server.dart';
import 'package:video_game_wish_list/common/widgets/centered_message.dart';

import 'home_page_state.dart';

class HomePage extends StatelessWidget {
  const HomePage._({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    final gameServer = Provider.of<GameServer>(context, listen: false);
    return BlocProvider<HomePageBloc>(
      create: (context) => HomePageBloc(HomePageState(), server: gameServer),
      child: HomePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover deals'),
        actions: [
          TextButton(
            onPressed: () => bloc.add(FilterButtonPressedEvent(context)),
            child: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state.hasError && state.dealCount == 0)
            return _buildErrorMessage(context);
          if (state.dealCount != 0)
            return _buildListView(context, state);
          else if (state.deals != null)
            return _buildEmptyPage();
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  CenteredMessage _buildEmptyPage() {
    return CenteredMessage(
      message: 'Nothing here...',
      secondaryMessage: 'Except for you and me :)',
    );
  }

  ListView _buildListView(BuildContext context, HomePageState state) {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    return ListView.separated(
        separatorBuilder: (_, __) => Divider(),
        itemCount:
            state.dealCount + (bloc.hasMorePages || state.hasError ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.dealCount) {
            if (state.hasError)
              return Row(
                children: [
                  TextButton(
                      onPressed: () => bloc.add(RetryLoadingButtonEvent()),
                      child: Icon(Icons.replay)),
                  Text('Something went wrong loading the deals'),
                ],
              );
            else
              return Center(child: CircularProgressIndicator());
          }
          bloc.add(RenderItemEvent(index));
          return _buildGridItem(context, state.deals![index]);
        });
  }

  Column _buildErrorMessage(BuildContext context) {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CenteredMessage(
          message: 'Something went wrong.',
          secondaryMessage: 'Please try again later',
        ),
        TextButton(
            onPressed: () => bloc.add(GetInitialPageEvent()),
            child: Icon(Icons.replay)),
      ],
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
