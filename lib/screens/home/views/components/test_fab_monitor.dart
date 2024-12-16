import 'package:flutter/material.dart';
import 'package:test/components/product/product_card.dart';
import 'package:test/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';
import 'package:test/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';

class TestFabMonitor extends StatefulWidget {
  const TestFabMonitor({super.key});
  @override
  _TestFabMonitorState createState() => _TestFabMonitorState();
}

class _TestFabMonitorState extends State<TestFabMonitor> {
  List<dynamic> _response = [];
  List<DataRow> _rows = [];
  Timer? _timer;
  final Logger _logger = Logger();
  @override
  void initState() {
    super.initState();
    _sendRequest();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _sendRequest();
    });
  }

  Future<void> _sendRequest() async {
    _logger.w('send request=====================================');
    //debugPrint('send request=====================================');
    final url = Uri.parse('https://mobileapi.vis.com.tw/api/fm/machine');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _response = json.decode(response.body)['data'];
          _rows = _response.map<DataRow>((item) {
            Color cellColor;
            switch (item['STATUS']) {
              case 'UP':
                cellColor = Colors.green;
                break;
              case 'Inactive':
                cellColor = Colors.red;
                break;
              case 'Maintenance':
                cellColor = Colors.yellow;
                break;
              default:
                cellColor = Colors.grey;
            }
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Container(
                    color: Colors.white,
                    child: Text(item['EQPID'] ?? 'N/A'),
                  ),
                ),
                DataCell(
                  Container(
                    color: cellColor,
                    child: Text(item['STATUS'] ?? 'N/A'),
                  ),
                ),
              ],
            );
          }).toList();
        });
      } else {
        setState(() {
          _response = [];
        });
      }
    } catch (e) {
      setState(() {
        print(e);
        _response = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Fab Monitor",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // Table 的UI顯示，必須佔滿畫面
        Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Container(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: DataTable(
                      sortAscending: true,
                      dataRowHeight: 32.0, // 設置行的高度
                      columnSpacing: 2.0, // 調整列之間的間距
                      headingRowHeight: 32.0,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('機台'),
                        ),
                        DataColumn(
                          label: Text('狀態'),
                        ),
                      ],
                      rows: _rows,
                    ),
                  ),
                ),
              ),
            )),
        // 顯示機台狀態
        // While loading use 👇
        // const ProductsSkelton(),
      ],
    );
  }
}
