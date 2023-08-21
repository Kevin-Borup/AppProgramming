import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'models.dart';

/// An object to set the pictureContainer collection data source to the datagrid. This
/// is used to map the picture data to the datagrid widget.
class PictureDataSource extends DataGridSource {
  /// Creates the picture data source class with required details.
  PictureDataSource({required List<PictureContainer> pictureData}) {
    _pictureData = pictureData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<Image>(columnName: 'Image', value: e.image),
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<int>(columnName: 'Height', value: e.height),
              DataGridCell<int>(columnName: 'Width', value: e.width),
              DataGridCell<String>(
                  columnName: 'FillType',
                  value: e.type.name.replaceAll("FillType", "")),
            ]))
        .toList();
  }

  List<DataGridRow> _pictureData = [];

  @override
  List<DataGridRow> get rows => _pictureData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
