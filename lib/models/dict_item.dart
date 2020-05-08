class Sample {
  final String x;
  final String trans;
  Sample({this.x, this.trans});
}

class DictItem {
  String phonetic = '';
  String question = '';
  String answer = '';

  String _exchange = '';
  String get exchange {
    return _exchange;
  }

  set exchange(String v) {
    _exchange = this.formatExchange(v);
  }

  List<Sample> _samples = [];
  List<Sample> get samples {
    return this._samples;
  }

  setSamples(String v) {
    if (v == null) {
      return;
    }

    if (v.length > 0) {
      var regexp = RegExp(r"<x>(.+?)</x><t>(.*?)</t>");
      var matches = regexp.allMatches(v);
      matches.forEach((amatch) {
        var x = amatch.group(1);
        var trans = amatch.group(2);
        this._samples.add(Sample(x: x, trans: trans));
      });
    }
  }

  String formatExchange(String exchange) {
    var ret = '';
    var exs = exchange.split('/');
    exs.forEach((String s) {
      var regexp = RegExp(r"^[pdi3rts01]:");
      Match match = regexp.firstMatch(s);
      if (match != null) {
        var prefix = s.substring(0, match.end);
        var v = s.substring(match.end);
        var desc = '';
        switch (prefix) {
          case 'p:':
            desc = '过去式';
            break;
          case 'd:':
            desc = '过去分词';
            break;
          case 'i:':
            desc = '现在分词';
            break;
          case '3:':
            desc = '第三人称单数';
            break;
          case 'r:':
            desc = '比较级';
            break;
          case 't:':
            desc = '最高级';
            break;
          case 's:':
            desc = '复数';
            break;
          case '0:':
            //desc = 'Lemma';
            break;
          case '1:':
            //desc = 'Lemma的变换形式';
            break;
        }
        if (desc.length > 0) {
          ret += '$desc $v\n';
        }
      } else {
        ret += '$s\n';
      }
    });

    ret = ret.trim();
    return ret;
  }

  @override
  String toString() {
    return '''
    DictItem of $question : 
    phonetic: $phonetic
    answer: $answer
    exchange: $exchange
    samples: $samples
    ''';
  }
}
