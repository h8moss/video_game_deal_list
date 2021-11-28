import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/home_page/home_page_bloc.dart';
import 'package:video_game_wish_list/app/home_page/home_page_event.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';
import 'package:video_game_wish_list/common/services/preferences_deal_server.dart';

import 'home_page_app_bar.dart';
import 'home_page_deal_list_view.dart';
import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  HomePage._({Key? key}) : super(key: key);

  static Widget create(
    BuildContext context,
  ) {
    final savedServer =
        Provider.of<PreferencesDealServer>(context, listen: false);
    final apiServer = Provider.of<ApiDealServer>(context, listen: false);

    return BlocProvider<HomePageBloc>(
      create: (context) =>
          HomePageBloc(HomePageState(), servers: [savedServer, apiServer]),
      child: HomePage._(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc get bloc => BlocProvider.of<HomePageBloc>(context);

  TextEditingController _searchFieldController = TextEditingController();

  @override
  void dispose() {
    bloc.close();
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: HomePageDealListView(
            deals: state.deals,
            isDone: !bloc.hasMorePages,
            onRenderCell: (int value) => bloc.add(RenderItem(value)),
            hasError: state.hasError,
            onRetryAppending: () => bloc.add(RetryLoadingButton()),
            onRetryLoading: () => bloc.add(GetInitialPage()),
            kAdCount: bloc.serverIndex *
                7, // ! if I add more servers this bit of code is insane
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books), label: 'Saved deals'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: 'Discover deals'),
            ],
            currentIndex: bloc.serverIndex,
            onTap: (i) => bloc.add(SetBottomNavigation(i)),
          ),
        );
      },
    );
  }

  HomePageAppBar _buildAppBar(HomePageState state) {
    return HomePageAppBar(
      hasFilter: bloc.selectedServer.hasFilter,
      hasSearch: bloc.selectedServer.hasSearch,
      isSearching: state.isSearching,
      label: bloc.serverIndex == 0 ? 'Saved deals' : 'Discover deals',
      onBackPressed: () => bloc.add(SetIsSearching(false)),
      onFilterPressed: () => bloc.add(FilterButtonPressed(context)),
      onSearchPressed: () => bloc.add(state.isSearching
          ? UpdateSearchTerm(_searchFieldController.text)
          : SetIsSearching(true)),
      onSearchSubmit: (String value) => bloc.add(UpdateSearchTerm(value)),
      searchFieldController: _searchFieldController,
    );
  }
}
