import 'dart:math';

class ObjectId {
  static String createOne() {
    var timestamp = (DateTime.now().millisecondsSinceEpoch / 1000)
        .round()
        .toRadixString(16);
    var random = Random();
    var deviceId = '';

    for (var i = 0; i < 16; i++) {
      var x = (random.nextInt(16)).toRadixString(16);
      deviceId += x;
    }

    return timestamp + deviceId.toLowerCase();
  }

  static int timestamp(String oid) {
    var ret = oid.substring(0, 8);
    return int.parse(ret, radix: 16);
  }
}
