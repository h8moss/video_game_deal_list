import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_bloc.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_event.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_state.dart';
import 'package:video_game_wish_list/common/store_display.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';
import '../../common/labeled_slider.dart';

typedef SectionBuilder = Widget Function(BuildContext, FilterSheetState);

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key, required this.filterModel})
      : super(key: key);

  final FilterModel filterModel;

  static Future<FilterModel> show(
      BuildContext context, FilterModel model) async {
    final server = Provider.of<GameServer>(context, listen: false);
    final FilterModel? resultModel = await showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider<FilterSheetBloc>(
        child: FilterBottomSheet(filterModel: model),
        create: (_) => FilterSheetBloc(FilterSheetState(), server),
      ),
    ) as FilterModel?;
    return resultModel ?? model;
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
            expansionCallback: (index, isExpanded) => bloc
                .add(ToggleExpandedPanel(FilterSheetSections.values[index])),
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
                  bloc.add(ToggleLowerPriceRange());
                }),
            Text('any'),
          ],
        ),
        _buildLabeledSlider(
          state.lowerPriceRange,
          (val) => bloc.add(SetLowerPriceRange(val.round())),
          !state.lowerPriceRangeIsAny,
        ),
        Divider(),
        Text('Higher price'),
        Row(
          children: [
            Checkbox(
              value: state.upperPriceRangeIsAny,
              onChanged: (value) => bloc.add(ToggleUpperPriceRange()),
            ),
            Text('Any')
          ],
        ),
        _buildLabeledSlider(
            state.upperPriceRange,
            (val) => bloc.add(SetUpperPriceRange(val.round())),
            !state.upperPriceRangeIsAny),
      ],
    );
  }

  Widget _buildLabeledSlider(
      int value, ValueChanged<double> callback, bool active) {
    return LabeledSlider(
      labelText: (active ? value.toString() : 'any'),
      value: value.toDouble(),
      onChanged: active ? callback : null,
      divisions: 50,
      max: 49,
      min: 0,
      secondaryLabel: (active ? value.toString() : '0') + '\$',
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
              onPressed: () => bloc.add(SetStoresValues(state.allStores)),
              child: Text('all'),
            ),
            TextButton(
              onPressed: () => bloc.add(SetStoresValues(state.activeStores)),
              child: Text('Only active'),
            ),
            TextButton(
              child: Text('None'),
              onPressed: () => bloc.add(SetStoresValues({})),
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
          onChanged: (_) {
            bloc.add(ToggleStoreValue(storeModel));
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
    return Container();
  }

  Widget _buildRatingBody(BuildContext context, FilterSheetState state) {
    return Container();
  }
}
