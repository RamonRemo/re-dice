import 'package:flutter/material.dart';
import 'package:re_dice/app/services/preferences_service.dart';
import 'package:re_dice/app/utils/constants.dart';

class HistoryModal extends StatelessWidget {
  const HistoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final history = PreferencesService.getRollHistory();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 800, maxHeight: 600),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Constants.matrixGreen),
        ),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Constants.matrixGreen),
              child: DataTable(
                dividerThickness: 1,
                columns: _buildColumns(),
                rows: _buildRows(history),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return ['Time', 'Value', 'Total'].map((title) {
      return DataColumn(
        label: Text(title, style: TextStyle(color: Constants.matrixGreen)),
      );
    }).toList();
  }

  List<DataRow> _buildRows(List<String> history) {
    return history.reversed.map((record) {
      final parts = record.split(':  ');
      final time = parts[0];
      final values = parts.length > 1 ? parts[1].split('  /  ') : ['', ''];

      return DataRow(
        cells: [
          DataCell(Text(time, style: TextStyle(color: Constants.matrixGreen))),
          DataCell(
            Text(values[0], style: TextStyle(color: Constants.matrixGreen)),
          ),
          DataCell(
            Text(values[1], style: TextStyle(color: Constants.matrixGreen)),
          ),
        ],
      );
    }).toList();
  }
}
