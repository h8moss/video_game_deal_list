import 'package:flutter/material.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'labeled_slider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key, required this.filterModel})
      : super(key: key);

  final FilterModel filterModel;

  static Future<FilterModel> show(
      BuildContext context, FilterModel model) async {
    final FilterModel? resultModel = await showModalBottomSheet(
        context: context,
        builder: (_) => FilterBottomSheet(filterModel: model)) as FilterModel?;
    return resultModel ?? model;
  }

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState(filterModel);
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  _FilterBottomSheetState(this.model);

  FilterModel model;
  List<bool> expanded = [];

  @override
  void initState() {
    expanded = List.filled(2, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context, model),
          child: Row(
            children: [
              Icon(Icons.check),
              Text('Done'),
              SizedBox(height: 10),
            ],
          ),
        ),
        ExpansionPanelList(
          expansionCallback: (index, isExpanded) =>
              setState(() => expanded[index] = !isExpanded),
          children: [
            ExpansionPanel(
              headerBuilder: (_, b) => Text('Price range'),
              body: _buildPriceRangeBody(),
              isExpanded: expanded[0],
            ),
            ExpansionPanel(
                headerBuilder: (_, b) => Text('Stores'),
                body: _buildStoresBody(),
                isExpanded: expanded[1])
          ],
        )
      ],
    );
  }

  Widget _buildPriceRangeBody() {
    return Column(
      children: [
        Text('Lower price'),
        Row(
          children: [
            Checkbox(
                value: model.lowerPrice == null,
                onChanged: (value) {
                  setState(() {
                    model.lowerPrice = value == true ? null : 0;
                  });
                }),
            Text('any'),
          ],
        ),
        _buildLabeledSlider(
          model.lowerPrice,
          (val) => setState(() => model.lowerPrice = val.round()),
        ),
        Divider(),
        Text('Higher price'),
        Row(
          children: [
            Checkbox(
              value: model.higherPrice == null,
              onChanged: (value) =>
                  setState(() => model.higherPrice = value == true ? null : 0),
            ),
            Text('Any')
          ],
        ),
        _buildLabeledSlider(
          model.higherPrice,
          (val) => setState(() => model.higherPrice = val.round()),
        ),
      ],
    );
  }

  Widget _buildLabeledSlider(int? value, ValueChanged<double> callback) {
    return LabeledSlider(
      labelText: (value?.toString() ?? 'any'),
      value: value?.toDouble() ?? 0,
      onChanged: value == null ? null : callback,
      divisions: 50,
      max: 49,
      min: 0,
      secondaryLabel: (value?.toString() ?? '0') + '\$',
    );
  }

  Widget _buildStoresBody() {
    return Container();
  }
}
