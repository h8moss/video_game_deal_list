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

class HomePage extends StatefulWidget {
  HomePage._({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    final gameServer = Provider.of<GameServer>(context, listen: false);
    return BlocProvider<HomePageBloc>(
      create: (context) => HomePageBloc(HomePageState(), server: gameServer),
      child: HomePage._(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    _searchController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: _buildScaffoldBody(state),
        );
      },
    );
  }

  AppBar _buildAppBar(HomePageState state) {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    bool isSearching = state.isSearching;
    return AppBar(
      title: isSearching
          ? TextField(
              onSubmitted: (val) => bloc.add(SetSearchTermEvent(val)),
              autofocus: true,
              controller: _searchController,
            )
          : Text('Discover deals'),
      actions: [
        TextButton(
          onPressed: () => bloc.add(FilterButtonPressedEvent(context)),
          child: Icon(
            Icons.filter_list,
            color: Colors.black,
          ),
        ),
        TextButton(
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () => bloc.add(isSearching
              ? SetSearchTermEvent(_searchController.text)
              : SetIsSearchingEvent(true)),
        )
      ],
      centerTitle: true,
      leading: isSearching
          ? TextButton(
              onPressed: () => bloc.add(SetIsSearchingEvent(false)),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))
          : null,
    );
  }

  Widget _buildEmptyPage() {
    return CenteredMessage(
      message: 'Nothing here...',
      secondaryMessage: 'Except for you and me :)',
    );
  }

  Widget _buildListView(HomePageState state) {
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
          return _buildGridItem(state.deals![index]);
        });
  }

  Widget _buildErrorMessage() {
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

  Widget _buildGridItem(DealModel model) {
    return Center(
      child: DealTile(
        onPressed: () => DealPageBuilder.show(context, model.id),
        saleModel: model,
      ),
    );
  }

  Widget _buildScaffoldBody(HomePageState state) {
    if (state.hasError && state.dealCount == 0) return _buildErrorMessage();
    if (state.dealCount != 0)
      return _buildListView(state);
    else if (state.deals != null)
      return _buildEmptyPage();
    else
      return Center(child: CircularProgressIndicator());
  }
}
