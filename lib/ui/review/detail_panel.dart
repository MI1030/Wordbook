import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../../models/kr.dart';
import '../../models/dict_item.dart';
import '../../blocs/review_bloc.dart';
import '../widgets/my_content_row.dart';
import '../styles/screen.dart';
import '../widgets/dict_content.dart';
import '../../colors.dart';
import 'phonetic_widget.dart';
import 'review_const.dart';

class DetailPanel extends StatelessWidget {
  const DetailPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.showKrDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return _buildPanel();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPanel() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    Kr kr = bloc.kr.value;
    return StreamBuilder(
      stream: bloc.showKrDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            //margin: EdgeInsets.all(Screen.instance.pageHmargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: MemofColors.background,
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: Screen.instance.pageHmargin,
              ),
              children: <Widget>[
                SizedBox(
                  height: Screen.instance.marginMedium,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Screen.instance.pageHmargin),
                  child: _buildQuestion(kr),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Screen.instance.pageHmargin),
                  child: PhoneticWidget(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Screen.instance.pageHmargin),
                  child: _buildMyContents(kr),
                ),
                if (bloc.dictItem.value != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Screen.instance.pageHmargin),
                    child: _buildDictContent(bloc.dictItem.value),
                  ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildQuestion(Kr kr) {
    return Text(
      kr.question,
      style: TextStyle(
        fontSize: Screen.instance.fontSizeTitle1,
        color: Colors.black,
      ),
      textAlign: TextAlign.left,
    );
  }

  _buildMyContents(Kr kr) {
    return MyContentRow(kr);
  }

  _buildDictContent(DictItem dictItem) {
    return DictContent(
      dictItem: dictItem,
      showChineseDefinition: true,
    );
  }
}
