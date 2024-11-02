import 'package:flutter/material.dart';
import 'package:test/components/product/product_card.dart';
import 'package:test/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';
import 'package:test/main.dart';

class TestTable extends StatelessWidget {
  const TestTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Table Example",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // Table 的UI顯示，必須佔滿畫面
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('商品名稱'),
                  ),
                  DataColumn(
                    label: Text('價格'),
                  ),
                  DataColumn(
                    label: Text('庫存'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) {
                    int stock = (index + 1) * 5;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (stock < 20) {
                            return Colors.red[100]; // 淡紅色
                          }
                          return null; // 默認顏色
                        },
                      ),
                      cells: <DataCell>[
                        DataCell(Text('商品 $index')),
                        DataCell(Text('\$${(index + 1) * 10}')),
                        DataCell(Text('$stock')),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // While loading use 👇
        // const ProductsSkelton(),
      ],
    );
  }
}
