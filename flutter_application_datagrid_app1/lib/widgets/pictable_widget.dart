import 'package:flutter/material.dart';
import 'package:flutter_application_datagrid_app1/blocs/pic_cons_bloc.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:flutter_application_datagrid_app1/widgets/pic_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/events/piccon_event.dart';
import '../data/states/piccons_states.dart';

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
    final PicConsBloc picBloc = BlocProvider.of<PicConsBloc>(context);
    picBloc.add(GetAllPicConsEvent());

    return Expanded(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: BlocBuilder<PicConsBloc, PicConState>(
        builder: (context, PicConState state) {
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
              rows: state.picCons
                  .map((PictureContainer picCon) => DataRow(
                          onSelectChanged: (val) => {
                                if (val != null && val)
                                  {_showImageDialog(context, picCon)}
                              },
                          cells: [
                            DataCell(picCon.image),
                            DataCell(Text(picCon.name))
                          ]))
                  .toList());
        },
      ),
    )));
  }
}
