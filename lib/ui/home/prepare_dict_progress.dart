import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../../blocs/dict_bloc.dart';
import '../widgets/progress_hud.dart';
import '../../localizations.dart';

class PrepareDictProgress extends StatelessWidget {
  const PrepareDictProgress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
    return StreamBuilder(
      stream: dictBloc.dbExists,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          if (snapshot.data) {
            return Container();
          } else {
            return ProgressHUD(
              backgroundColor: Colors.black12,
              color: Colors.blue,
              containerColor: Colors.white,
              borderRadius: 5.0,
              text: MemofLocalizations.of(context).prepareDictionary,
              loading: true,
            );
          }
        }
      },
    );
  }
}
