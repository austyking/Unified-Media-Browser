import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/views/detail_page/detail_shell.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (context, state) {
        print('DetailState is: $state');

        if (state is DetailStateInitial) {
          return DetailShell();
        }
        if (state is DetailStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is DetailStateError) {
          return Text(state.error);
        }
        return Text('Default');
      },
    );
  }
}
