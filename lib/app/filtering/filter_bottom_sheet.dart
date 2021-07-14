import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_bloc.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_event.dart';
import 'package:video_game_wish_list/app/filtering/filter_sheet_model.dart';
import 'package:video_game_wish_list/common/store_display.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';
import '../../common/labeled_slider.dart';

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
        create: (_) => FilterSheetBloc(FilterSheetModel(), server),
      ),
    ) as FilterModel?;
    return resultModel ?? model;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return BlocBuilder<FilterSheetBloc, FilterSheetModel>(
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
            animationDuration: Duration(milliseconds: 500),
            expansionCallback: (index, isExpanded) => bloc
                .add(ToggleExpandedPanel(FilterSheetSections.values[index])),
            children: [
              ExpansionPanel(
                headerBuilder: (_, b) => Text('Price range'),
                body: _buildPriceRangeBody(context, state),
                isExpanded:
                    state.getSectionExpansion(FilterSheetSections.PriceRange),
              ),
              ExpansionPanel(
                headerBuilder: (_, b) => Text('Stores'),
                body: _buildStoresBody(context, state),
                isExpanded:
                    state.getSectionExpansion(FilterSheetSections.Stores),
              ),
              ExpansionPanel(
                headerBuilder: (_, __) => Text('Sorting'),
                body: _buildSortBody(context, state),
                isExpanded:
                    state.getSectionExpansion(FilterSheetSections.Sorting),
              ),
              ExpansionPanel(
                headerBuilder: (_, __) => Text('Rating'),
                body: _buildRatingBody(context, state),
                isExpanded:
                    state.getSectionExpansion(FilterSheetSections.Rating),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPriceRangeBody(BuildContext context, FilterSheetModel model) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Column(
      children: [
        Text('Lower price'),
        Row(
          children: [
            Checkbox(
                value: model.lowerPriceRangeIsAny,
                onChanged: (value) {
                  bloc.add(ToggleLowerPriceRange());
                }),
            Text('any'),
          ],
        ),
        _buildLabeledSlider(
          model.lowerPriceRange,
          (val) => bloc.add(SetLowerPriceRange(val.round())),
          !model.lowerPriceRangeIsAny,
        ),
        Divider(),
        Text('Higher price'),
        Row(
          children: [
            Checkbox(
              value: model.upperPriceRangeIsAny,
              onChanged: (value) => bloc.add(ToggleUpperPriceRange()),
            ),
            Text('Any')
          ],
        ),
        _buildLabeledSlider(
            model.upperPriceRange,
            (val) => bloc.add(SetUpperPriceRange(val.round())),
            !model.upperPriceRangeIsAny),
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

  Widget _buildStoresBody(BuildContext context, FilterSheetModel model) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: model.storeSelectionIsAny,
              onChanged: model.storeSelectionIsActive
                  ? null
                  : (val) {
                      bloc.add(SetStoreSelection(val == true
                          ? StoreSelectionState.Any
                          : StoreSelectionState.Selected));
                    },
            ),
            Text(
              'Any',
              style: TextStyle(
                  color: model.storeSelectionIsActive ? Colors.black38 : null),
            ),
            Divider(),
            Checkbox(
              value: model.storeSelectionIsActive,
              onChanged: model.storeSelectionIsAny
                  ? null
                  : (val) {
                      bloc.add(SetStoreSelection(val == true
                          ? StoreSelectionState.Active
                          : StoreSelectionState.Selected));
                    },
            ),
            Text(
              'Only active',
              style: TextStyle(
                  color: model.storeSelectionIsAny ? Colors.black38 : null),
            ),
          ],
        ),
        if (model.stores != null)
          ...model.stores!
              .map((v) => _buildStoreCheckbox(context, v, model))
              .toList()
        else
          CircularProgressIndicator(),
      ],
    );
  }

  _buildStoreCheckbox(
      BuildContext context, StoreModel storeModel, FilterSheetModel model) {
    final bloc = BlocProvider.of<FilterSheetBloc>(context);
    return Row(
      children: [
        Checkbox(
          value: model.isStoreSelected(storeModel),
          onChanged: model.storeSelectionIsSelected
              ? (_) {
                  bloc.add(ToggleStoreValue(storeModel));
                }
              : null,
        ),
        StoreDisplay(
          model: storeModel,
          width: 20,
          textColor: model.storeSelectionIsSelected ? null : Colors.black38,
        ),
      ],
    );
  }

  Widget _buildSortBody(BuildContext context, FilterSheetModel model) {
    return Container();
  }

  Widget _buildRatingBody(BuildContext context, FilterSheetModel model) {
    return Container();
  }
}
