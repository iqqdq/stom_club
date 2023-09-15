import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/models/manufacturer_filter_view_model.dart';
import 'package:stom_club/screens/manufacturer_filter/manufacturer_filter_screen_body.dart';

class ManufacturerFilterScreenWidget extends StatelessWidget {
  final List<Manufacturer> selectedManufactures;
  final Function(List<Manufacturer>) didReturnValue;

  const ManufacturerFilterScreenWidget(
      {Key? key,
      required this.didReturnValue,
      required this.selectedManufactures})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ManufacturerFilterViewModel(selectedManufactures),
        child:
            ManufacturerFilterScreenBodyWidget(didReturnValue: didReturnValue));
  }
}
