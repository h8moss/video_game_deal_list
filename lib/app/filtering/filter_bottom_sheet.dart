import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_bloc.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_sheet_state.dart';
import 'package:video_game_wish_list/common/services/game_server.dart';
import 'package:video_game_wish_list/common/widgets/store_display.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';
import '../../common/widgets/labeled_slider.dart';
import 'filter_sheet_event.dart';

typedef SectionBuilder = Widget Function(BuildContext, FilterSheetState);

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key, required this.filterModel})
      : super(key: key);

  final FilterModel filterModel;

  static Future<FilterModel?> show(
      BuildContext context, FilterModel model) async {
    final server = Provider.of<GameServer>(context, listen: false);
    final FilterModel? resultModel = await showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider<FilterSheetBloc>(
        child: FilterBottomSheet(filterModel: model),
        create: (_) =>
            FilterSheetBloc(FilterSheetState.fromFilter(model), server),
      ),
    ) as FilterModel?;
    return resultModel;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return BlocBuilder<FilterSheetBloc, FilterSheetState>(
      builder: (context, state) => ListView(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context, state.filterModel),
            child: Row(
              children: [
                Icon(Icons.check),
                Text('Done'),
                SizedBox(height: 10),
              ],
            ),
          ),
          ExpansionPanelList(
            animationDuration: Duration(seconds: 1),
            expansionCallback: (index, isExpanded) => bloc.add(SetExpandedPanel(
                FilterSheetSections.values[index], !isExpanded)),
            children: [
              for (var item in FilterSheetSections.values)
                ExpansionPanel(
                  headerBuilder: (_, b) => Text(
                      bloc.filterSheetSectionsNames(item),
                      style: TextStyle(fontSize: 19)),
                  body: _getSectionBuilder(item)(context, state),
                  isExpanded: state.getSectionExpansion(item),
                ),
            ],
          )
        ],
      ),
    );
  }

  SectionBuilder _getSectionBuilder(FilterSheetSections section) {
    switch (section) {
      case FilterSheetSections.PriceRange:
        return _buildPriceRangeBody;
      case FilterSheetSections.Stores:
        return _buildStoresBody;
      case FilterSheetSections.Sorting:
        return _buildSortBody;
      case FilterSheetSections.Rating:
        return _buildRatingBody;
      case FilterSheetSections.Other:
        return _buildOtherBody;
    }
  }

  Widget _buildPriceRangeBody(BuildContext context, FilterSheetState state) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Column(
      children: [
        Text('Lower price'),
        Row(
          children: [
            Checkbox(
                value: state.lowerPriceRangeIsAny,
                onChanged: (value) {
                  bloc.add(SetFilterValues(lowerPriceRangeIsAny: value));
                }),
            Text('any'),
          ],
        ),
        _buildLabeledSlider(
          state.lowerPriceRange,
          (val) => bloc.add(SetFilterValues(lowerPriceRange: val.round())),
          !state.lowerPriceRangeIsAny,
          true,
        ),
        Divider(),
        Text('Higher price'),
        Row(
          children: [
            Checkbox(
              value: state.upperPriceRangeIsAny,
              onChanged: (value) =>
                  bloc.add(SetFilterValues(upperPriceRangeIsAny: value)),
            ),
            Text('Any')
          ],
        ),
        _buildLabeledSlider(
            state.upperPriceRange,
            (val) => bloc.add(SetFilterValues(upperPriceRange: val.round())),
            !state.upperPriceRangeIsAny,
            true),
      ],
    );
  }

  Widget _buildLabeledSlider(
      int value, ValueChanged<double> callback, bool active, bool useDollar) {
    return LabeledSlider(
      labelText:
          (active ? (value.toString() + (useDollar ? '\$' : '')) : 'any'),
      value: value.toDouble(),
      onChanged: active ? callback : null,
      divisions: 50,
      max: 49,
      min: 0,
      secondaryLabel:
          (active ? value.toString() : '0') + (useDollar ? '\$' : ''),
    );
  }

  Widget _buildStoresBody(BuildContext context, FilterSheetState state) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () =>
                  bloc.add(SetFilterValues(storeValues: state.allStores)),
              child: Text('all'),
            ),
            TextButton(
              onPressed: () =>
                  bloc.add(SetFilterValues(storeValues: state.activeStores)),
              child: Text('Only active'),
            ),
            TextButton(
              child: Text('None'),
              onPressed: () => bloc.add(SetFilterValues(storeValues: {})),
            ),
          ],
        ),
        if (state.stores != null)
          ...state.stores!
              .map((v) => _buildStoreCheckbox(context, v, state))
              .toList()
        else
          CircularProgressIndicator(),
      ],
    );
  }

  _buildStoreCheckbox(
      BuildContext context, StoreModel storeModel, FilterSheetState state) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Row(
      children: [
        Checkbox(
          value: state.isStoreSelected(storeModel),
          onChanged: (value) {
            bloc.add(SetStoreSelection(storeModel, value!));
          },
        ),
        StoreDisplay(
          model: storeModel,
          width: 20,
        ),
      ],
    );
  }

  Widget _buildSortBody(BuildContext context, FilterSheetState state) {
    return Column(
      children: [
        for (DealSortingStyle sort in DealSortingStyle.values)
          _buildSortDisplay(context, state, sort),
      ],
    );
  }

  Widget _buildSortDisplay(
      BuildContext context, FilterSheetState state, DealSortingStyle sort) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    bool? isDescending = state.isSortDescending(sort);
    Widget icon = isDescending == true
        ? Icon(Icons.arrow_downward)
        : isDescending == false
            ? Icon(Icons.arrow_upward)
            : Container();

    return Column(
      children: [
        TextButton(
          onPressed: () => bloc.add(SetFilterValues(sort: sort)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bloc.dealSortingNames(sort)),
              SizedBox(
                width: 20,
                child: icon,
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildRatingBody(BuildContext context, FilterSheetState state) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Column(
      children: [
        Text('Metacritic Score'),
        Row(
          children: [
            Checkbox(
              value: state.metacriticScoreIsAny,
              onChanged: (val) =>
                  bloc.add(SetFilterValues(metacriticScoreIsAny: val)),
            ),
            Text('Any'),
          ],
        ),
        _buildLabeledSlider(
          state.metacriticScore,
          (value) => bloc.add(SetFilterValues(metacriticScore: value.round())),
          !state.metacriticScoreIsAny,
          false,
        ),
        Divider(),
        Text('Steam Score'),
        Row(
          children: [
            Checkbox(
              value: state.steamScoreIsAny,
              onChanged: (val) =>
                  bloc.add(SetFilterValues(steamScoreIsAny: val)),
            ),
            Text('Any'),
          ],
        ),
        _buildLabeledSlider(
          state.steamScore,
          (value) => bloc.add(SetFilterValues(steamScore: value.round())),
          !state.steamScoreIsAny,
          false,
        ),
      ],
    );
  }

  Widget _buildOtherBody(BuildContext context, FilterSheetState state) {
    return Container();
  }
}
