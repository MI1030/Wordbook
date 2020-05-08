import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/kr.dart';
import '../../models/dict_item.dart';
import '../../blocs/review_bloc.dart';
import '../widgets/phonetic_row.dart';
import '../widgets/no_text_speaker.dart';
import 'review_const.dart';

class PhoneticWidget extends StatelessWidget {
  final bool showText;
  PhoneticWidget({this.showText = true});

  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    final s = Observable.combineLatest2(bloc.kr, bloc.dictItem,
        (Kr kr, DictItem dictkr) {
      final Map<String, dynamic> ret = {'phonetic': ''};
      if (kr != null) {
        ret['kr'] = kr;
        ret['phonetic'] = dictkr?.phonetic;
        return ret;
      } else {
        return null;
      }
    }).asBroadcastStream();

    return StreamBuilder(
      stream: s,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          final Map<String, dynamic> r = snapshot.data;
          final phonetic = r['phonetic'];
          Kr kr = r['kr'];
          return showText ? PhoneticRow(phonetic, kr) : NoTextSpeaker(kr);
        } else {
          return Container();
        }
      },
    );
  }
}
