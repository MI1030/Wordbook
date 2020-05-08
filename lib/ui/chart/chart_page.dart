import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../styles/screen.dart';
import '../../localizations.dart';
import '../../blocs/chart_bloc.dart';

class ChartPage extends StatefulWidget {
  final int period;

  ChartPage(this.period);

  @override
  State<StatefulWidget> createState() {
    return _ChartPageState();
  }
}

class _ChartPageState extends State<ChartPage>
    with SingleTickerProviderStateMixin {
  List<ChartBloc> _chartBlocs;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _chartBlocs = [ChartBloc(1), ChartBloc(2)];
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _chartBlocs.forEach((abloc) => abloc.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = widget.period - 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(MemofLocalizations.of(context).statistics),
        bottom: TabBar(
          tabs: [
            Tab(
              text: MemofLocalizations.of(context).lastest30Days,
            ),
            Tab(
              text: MemofLocalizations.of(context).oneYear,
            )
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: SafeArea(
        child: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildChart(_chartBlocs[0]),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildChart(_chartBlocs[1]),
              ],
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  Widget _buildChart(ChartBloc bloc) {
    double height = MediaQuery.of(context).size.height -
        Screen.topBarHeight(context) * 3 -
        MediaQuery.of(context).padding.bottom * 2;
    return StreamBuilder(
      stream: bloc.series,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Padding(
            padding: EdgeInsets.all(32.0),
            child: Container(
              height: height,
              child: charts.TimeSeriesChart(
                snapshot.data,
                animate: true,
                behaviors: [
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.top,
                    desiredMaxRows: 2,
                  ),
                ],
                defaultRenderer: charts.BarRendererConfig<DateTime>(),
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickProviderSpec:
                      charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
                ),
                domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    day: charts.TimeFormatterSpec(
                      format: widget.period == 1 ? 'd' : 'M',
                      transitionFormat: widget.period == 1 ? 'M/d' : 'yy/M',
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
