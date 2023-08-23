import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:flutter_application_datagrid_app1/providers/pic_image_provider.dart';
import 'package:flutter_application_datagrid_app1/widgets/pic_dialog_widget.dart';
import 'package:provider/provider.dart';

class PicTable extends StatelessWidget {
  const PicTable({super.key});

  void _showImageDialog(BuildContext context, PictureContainer picCon) {
    showDialog(
        context: context,
        builder: (context) {
          return PicDialog(picCon);
        });
  }


  @override
  Widget build(BuildContext context) {
    final picConProvider = Provider.of<PicImageProvider>(context);
    return DataTable(
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text('Image'),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text('Name'),
            ),
          )
        ],
        rows: picConProvider.picCons
            .map((PictureContainer picCon) =>
            DataRow(
                onSelectChanged: (val) =>
                {
                  if (val != null && val)
                    {_showImageDialog(context, picCon)}
                },
                cells: [
                  DataCell(picCon.image),
                  DataCell(Text(picCon.name))
                ]))
            .toList());
  }
}
