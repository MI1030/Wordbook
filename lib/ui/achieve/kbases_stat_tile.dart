import 'package:flutter/material.dart';

import '../widgets/round_text_button.dart';
import '../../blocs/kbases_stat_tile_bloc.dart';
import '../achieve/achieve_page.dart';

class KbasesStatTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KbasesStatTileState();
  }
}

class _KbasesStatTileState extends State<KbasesStatTile> {
  KbasesStatTileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = KbasesStatTileBloc();
    _bloc.updateCount();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.totalCount,
      builder: (context, AsyncSnapshot<List<KbaseCountData>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 1) {
          var kbases = snapshot.data;
          var children = kbases.map((akbase) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  RoundTextButton.small(
                    bgColor: Color(0xffbbbbbb),
                    titleColor: Colors.white,
                    title: akbase.count.toString(),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return AchievePage(
                          kbaseId: akbase.kbase.iid,
                        );
                      }));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    akbase.kbase.name,
                    style: TextStyle(fontSize: 12, color: Color(0xff666666)),
                  )
                ],
              ),
            );
          }).toList();
          return Wrap(
            alignment: WrapAlignment.center,
            children: children,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
