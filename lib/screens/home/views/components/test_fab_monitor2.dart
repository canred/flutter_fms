import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class TestTable2 extends StatelessWidget {
  const TestTable2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                columns: [
                  DataColumn2(
                    label: Text('Column A'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('Column B'),
                  ),
                  DataColumn(
                    label: Text('Column C'),
                  ),
                  DataColumn(
                    label: Text('Column D'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('A$index')),
                      DataCell(Text('B$index')),
                      DataCell(Text('C$index')),
                      DataCell(Text('D$index')),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
