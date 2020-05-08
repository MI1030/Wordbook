import '../../../models/memstat_period.dart';

abstract class GraphPeriod {
  String get name;

  MemstatPeriod get tableType;

  int get step;

  int get beginTime;

  int get realCount;

  int pos(int ts0);

  String tsTag(int ts0, int index);

  int ts0(int ts0, int index);
}
