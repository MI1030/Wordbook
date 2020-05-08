import 'package:flutter/foundation.dart';
import '../biz/quiz_type.dart';

class Kbase {
  final String name;
  final int iid;
  final String questionTitle;
  final String answerTitle;
  final String samplesTitle;
  final int questionLines;
  final int answerLines;
  final int samplesLines;
  Kbase({
    @required this.name,
    @required this.iid,
    @required this.questionTitle,
    @required this.answerTitle,
    @required this.samplesTitle,
    @required this.questionLines,
    @required this.answerLines,
    @required this.samplesLines,
  });

  static Kbase word = Kbase(
      iid: 1,
      name: '单词',
      questionTitle: '单词',
      answerTitle: '解释',
      samplesTitle: '例句',
      questionLines: 2,
      answerLines: 3,
      samplesLines: 4);

  static List<Kbase> all = [
    word,
  ];

  static String nameOfIid(int iid) {
    return all.firstWhere((v) {
      return v.iid == iid;
    }).name;
  }

  static Kbase kbaseOfIid(int iid) {
    return all.firstWhere((akbase) => akbase.iid == iid);
  }

  static QuizType qtype({@required int level, @required int kbiid}) {
    List<QuizType> scheme;

    scheme = [
      QuizType.Word_Choice, // 0
      QuizType.Reverse_Word_Choice, // 1
      QuizType.Word_Choice, // 2
      QuizType.Reverse_Word_Choice, // 3
      QuizType.Normal, // 4
      QuizType.Word_Choice, // 5
      QuizType.Word_Choice, // 6
      QuizType.Reverse_Word_Choice, // 7
      QuizType.Normal, // 8
      QuizType.Word_Choice, // 9
      QuizType.Normal, // 10
      QuizType.Word_Choice, // 11
      QuizType.Reverse_Word_Choice, // 12
      QuizType.Word_Choice, // 13
      QuizType.Normal, // 14
      QuizType.Normal // 15
    ];

    QuizType ret = QuizType.Normal;
    if (level >= 0 && level < scheme.length) {
      ret = scheme[level];
    }
    return ret;
  }
}
