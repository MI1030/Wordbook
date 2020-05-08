import '../../models/pref_item.dart';
import '../prefs.dart';
import '../mem_db.dart';

class ReviewCountPerTurnOptions {
  static const String Title = '每次复习个数';
  static List<OptionItem> options() {
    return [
      OptionItem(text: '10', value: 10),
      OptionItem(text: '15', value: 15),
      OptionItem(text: '20', value: 20),
      OptionItem(text: '25', value: 25)
    ];
  }

  static PrefItem prefItem(int current) {
    var opts = options();
    var ret = PrefItemWithOptions(
      type: ReviewCountPerTurnOptions,
      title: Title,
      options: opts,
    );

    ret.current = opts.firstWhere(
      (OptionItem aitem) => aitem.value == current,
      orElse: () => opts[2],
    );

    return ret;
  }

  static Future<int> currentValue() async {
    MemofPrefs allPrefs = await MemDb.instance.prefs().all();
    return allPrefs.reviewCountPerTurn;
  }

  static Future save(int v) async {
    await MemDb.instance.prefs().setReviewCountPerTurn(v);
  }
}
