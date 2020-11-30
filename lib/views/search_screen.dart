import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:media_browser/views/helpers.dart';
import 'package:shimmer/shimmer.dart';

import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/models/utelly/utelly_models.dart';
import 'package:media_browser/controllers/controllers.dart';

import 'detail_page/detail_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_SearchBar(), _SearchBody()],
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  UtellySearchBloc _utellySearchBloc;

  @override
  void initState() {
    super.initState();
    _utellySearchBloc = BlocProvider.of<UtellySearchBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _utellySearchBloc.add(
          TextChanged(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _utellySearchBloc.add(TextChanged(text: ''));
  }
}

// ----------------------- SEARCH BODY -----------------------------------------
class _SearchBody extends StatelessWidget {
  final OmdbRepository omdbRepository = OmdbRepository(
    OmdbCache(),
    OmdbClient()
  );

  Widget _showMessage(String message) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UtellySearchBloc, UtellySearchState>(
      builder: (context, state) {
        print('state is: $state');

        if (state is SearchStateLoading) {
          return Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[400],
                  highlightColor: Colors.white,
                  child: Card(
                    child: ListTile(
                      title: Text('hello there'),
                      subtitle: Text('hello there'),
                    ),
                  ),
              )
           )
          );
        }
        if (state is SearchStateError) {
          return _showMessage(state.error);
        }
        if (state is SearchStateSuccess) {
          print('state.items.isempty: ${state.items.isEmpty}');
          return state.items.isEmpty ? _showMessage('No Results')
            : Expanded(child: _SearchResults(items: state.items,
                omdbRepository: omdbRepository,)
          );
        }
        return _showMessage('Please enter a term to begin');
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final OmdbRepository omdbRepository;
  final List<UtellySearchResultItem> items;

  const _SearchResults({Key key, @required this.omdbRepository,
    @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(
          item: items[index],
          omdbRepository: omdbRepository,
        );
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final UtellySearchResultItem item;
  final OmdbRepository omdbRepository;

  const _SearchResultItem({Key key, @required this.item, @required this.omdbRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemWidth = MediaQuery.of(context).size.width * 0.30;
    var itemHeight = itemWidth * 0.5625; // 16:9 aspect ratio
    var padWidth = itemWidth * 0.05;

    return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<DetailBloc>(
                        create: (context) => DetailBloc(searchResultItem: item)
                    ),
                    BlocProvider<OverviewBloc>(
                        create: (context) => OverviewBloc(
                          omdbRepository,
                          item,
                        )
                    )
                  ],
                  child: DetailScreen(),
                )
              )
            );
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(padWidth),
                child: SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: Hero(
                    tag: 'displayImage.${item.id}',
                    child: NullableNetworkWidget(
                      url: item.pictureUrl,
                      childBuilder: () => CachedNetworkImage(
                          placeholder: (context, url) => LoadingCard(
                              itemWidth: itemWidth,
                              itemHeight: itemHeight
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Center(child: Icon(Icons.error_outline)),
                          ),
                          imageUrl: item.pictureUrl,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      padWidth, padWidth, padWidth * 2,
                      padWidth),
                  child: AutoSizeText(
                    item.name,
                    style: TextStyle(fontSize: 20),
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
