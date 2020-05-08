import 'package:flutter_test/flutter_test.dart';
import 'package:mxxd/biz/object_id.dart';

void main() {
  test("ObjectId's length should be 24", () {
    var aId = ObjectId.createOne();
    expect(aId.length, 24);
    expect(aId, matches(RegExp(r"^[0123456789abcdef]+$")));
  });

  test("timestamp is now", () {
    var aId = ObjectId.createOne();
    var ts = ObjectId.timestamp(aId);
    var now = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    expect(ts, closeTo(now, 1));
  });
}
