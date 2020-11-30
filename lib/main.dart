import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/controllers/controllers.dart';
import 'package:media_browser/views/views.dart';

// DEBUG
import 'package:flutter/scheduler.dart' show timeDilation;

void main() {
  timeDilation = 1.0; // DEBUG: animation speed factor

  final UtellyRepository _utellyRepository = UtellyRepository(
    UtellyCache(),
    UtellyClient(),
  );

  runApp(App(utellyRepository: _utellyRepository));
}

class App extends StatelessWidget {
  final UtellyRepository utellyRepository;

  const App({
    Key key,
    @required this.utellyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Search',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Media Search')),
        body: BlocProvider(
          create: (context) =>
              UtellySearchBloc(utellyRepository: utellyRepository),
          child: SearchScreen(),
        ),
      ),
    );
  }
}
