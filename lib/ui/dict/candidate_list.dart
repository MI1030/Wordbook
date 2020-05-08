import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../../localizations.dart';
import '../../models/candidate.dart';
import '../../blocs/dict_bloc.dart';
import '../../blocs/dict_page_bloc.dart';
import '../../blocs/app_bloc.dart';

class CandidateList extends StatelessWidget {
  final DictPageBloc dictPageBloc;

  CandidateList(this.dictPageBloc);

  @override
  Widget build(BuildContext context) {
    DictBloc bloc = BlocProvider.getBloc<DictBloc>();
    return Expanded(
      child: StreamBuilder(
          stream: bloc.candidates,
          builder:
              (BuildContext context, AsyncSnapshot<List<Candidate>> snapshot) {
            if (snapshot.hasData) {
              return _buildResult(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Container();
          }),
    );
  }

  Widget _buildResult(context, List<Candidate> candidates) {
    DictBloc bloc = BlocProvider.getBloc<DictBloc>();
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        if (index >= candidates.length) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              fillColor: Color(0xfff0f0f0),
              child: Text(MemofLocalizations.of(context).noResult),
              onPressed: () {
                dictPageBloc.setContentType(DictContentType.Result);

                DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
                dictBloc.fetchKr(bloc.textofSearching.value);

                BlocProvider.getBloc<AppBloc>()
                    .memBloc
                    .fetchMem(bloc.textofSearching.value);
              },
            ),
          );
        } else {
          Candidate candidate = candidates[index];

          return ListTile(
            title: Text(candidate.question),
            subtitle: Text(
              candidate.answer,
              maxLines: 1,
            ),
            onTap: () {
              dictPageBloc.setContentType(DictContentType.Result);

              DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
              dictBloc.fetchKr(candidate.question);

              BlocProvider.getBloc<AppBloc>()
                  .memBloc
                  .fetchMem(candidate.question);
            },
          );
        }
      },
      itemCount: max(candidates.length, 1),
    );
  }
}
