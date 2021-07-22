import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/app/deals/deal_tile.dart';
import 'package:video_game_wish_list/app/home_page/home_page_bloc.dart';
import 'package:video_game_wish_list/app/home_page/home_page_event.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/common/services/game_server.dart';

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
          if (state.deals != null && state.dealCount != 0)
            return ListView.separated(
                separatorBuilder: (_, __) => Divider(),
                itemCount: state.dealCount + (bloc.hasMorePages ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.dealCount)
                    return Center(child: CircularProgressIndicator());
                  bloc.add(RenderItemEvent(index));
                  return _buildGridItem(context, state.deals![index]);
                });
          else if (state.deals != null)
            return Center(child: Text('Nothing here'));
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
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
