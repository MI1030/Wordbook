import '../../models/pref_item.dart';
import '../prefs.dart';
import '../mem_db.dart';
import '../../biz/mem_const.dart';

class ReviewOrderOptions {
  static const String Title = '复习顺序';
  static List<OptionItem> options() {
    return [
      OptionItem(text: '先易后难', value: ReviewOrder.EasyFirst.index),
      OptionItem(text: '先难后易', value: ReviewOrder.HardFirst.index),
      OptionItem(text: '随机顺序', value: ReviewOrder.Random.index),
    ];
  }

  static PrefItem prefItem(int current) {
    var opts = options();
    var ret = PrefItemWithOptions(
      type: ReviewOrderOptions,
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
    return allPrefs.reviewOrder;
  }

  static Future save(int v) async {
    await MemDb.instance.prefs().setReviewOrder(v);
  }
}
