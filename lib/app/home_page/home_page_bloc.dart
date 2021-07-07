import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

class HomePageBloc extends Bloc<HomePageEvent, List<DealModel>> {
  HomePageBloc(
    List<DealModel> initialState, {
    required this.server,
  }) : super(initialState) {
    getPage0();
  }

  final GameServer server;
  int currentPage = 0;
  int totalPages = 1;

  bool get hasMorePages => currentPage < totalPages - 1;

  @override
  Stream<List<DealModel>> mapEventToState(HomePageEvent event) async* {
    if (event is AppendDealsEvent) yield [...state, ...event.deals];
    if (event is SetDealsEvent) yield event.deals;
  }

  void onRender(int i) async {
    int threshold = currentPage * 60 - 5;
    print('rendering $i');
    if (i >= threshold) {
      print('Past threshold!');
      if (hasMorePages) {
        currentPage++;
        final items = await server.fetchGames(currentPage);
        // totalResults = items.totalResults;
        add(AppendDealsEvent(items.results));
      }
    }
  }

  Future<void> getPage0() async {
    final page0 = await server.fetchGames(0);
    currentPage = 0;
    add(SetDealsEvent(page0.results));
  }
}

class HomePageEvent {
  HomePageEvent();
}

class AppendDealsEvent extends HomePageEvent {
  AppendDealsEvent(this.deals) : super();

  final List<DealModel> deals;
}

class SetDealsEvent extends HomePageEvent {
  SetDealsEvent(this.deals) : super();

  final List<DealModel> deals;
}
