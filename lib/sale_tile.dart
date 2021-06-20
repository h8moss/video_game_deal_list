import 'package:flutter/material.dart';

import 'models/sale_model.dart';

class SaleTile extends StatelessWidget {
  SaleTile(this.saleModel);

  final SaleModel saleModel;

  @override
  Widget build(BuildContext context) {
    return Text(saleModel.gameName);
  }
}
