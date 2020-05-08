import 'package:flutter_test/flutter_test.dart';
import 'package:mxxd/utils/string_has_chinese.dart';

void main() {
  test("Chinese string should return true", () {
    String s = 'a只b';
    expect(StringHasChinese.hasChinese(s), isTrue);
  });

  test("English string should return false", () {
    String s = 'abc.。';
    expect(StringHasChinese.hasChinese(s), isFalse);
  });
}
