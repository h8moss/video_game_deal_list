import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/deals/deal_page_builder.dart';
import 'package:video_game_wish_list/app/deals/deal_tile.dart';
import 'package:video_game_wish_list/app/home_page/home_page_bloc.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

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
            onPressed: () => bloc.onFiltering(context),
            child: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          return ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: state.dealCount + (bloc.hasMorePages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.dealCount)
                  return Center(child: CircularProgressIndicator());
                bloc.onRender(index);
                return _buildGridItem(context, state.deals[index]);
              });
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
