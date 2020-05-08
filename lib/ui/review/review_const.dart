import 'package:bloc_pattern/bloc_pattern.dart';

import '../../blocs/review_bloc.dart';

class ReviewConst {
  static const double BottomPadding = 100;

  static ReviewBloc get reviewBloc =>
      BlocProvider.tag('ReviewModule').getBloc<ReviewBloc>();
}
