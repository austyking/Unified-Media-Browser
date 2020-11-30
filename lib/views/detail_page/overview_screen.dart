import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/models/utelly/utelly_search_result_item.dart';
import 'package:media_browser/views/helpers.dart';
import 'package:shimmer/shimmer.dart';
import 'package:expandable/expandable.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  // May need this to dispatch any future events on overview screen
  OverviewBloc _overviewBloc;

  @override
  void initState() {
    super.initState();
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
  }

  // Helper to build a card which can be clicked to trigger an expand
  Widget _buildExpandableCard({Widget body, List<Widget> bottom}) {
    return ExpandableButton(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: body,
              ),
            ],
          ),
          Divider(height: 2, color: Colors.transparent,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bottom,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building OverviewScreen');
    double height = MediaQuery.of(context).size.height;
    // padding at bottom of body
    double bottomPadding = height * 0.02;
    // height of provider icons
    double tileHeight = height * 0.1;
    // # of lines displayed in collapsed description
    int descLines = height > 800 ? 5 : 4;

    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        print('OverviewScreen state is: $state');

        // TODO before Overview returns, we can build the "Available On" widget
        // would just need to use OverviewStateLoading and put shimmer loading
        // cards for the rest

        if (state is OverviewStateSuccess) {
          return ExpandableNotifier(
            // Wrap > ListView bc we want a single scroll controller for the
            //  whole detail page.
            // Wrap > Column bc we don't want overflow bars.
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: FractionallySizedBox(
                widthFactor: 0.95,
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: tileHeight,
                      child: ProviderTile(
                        tileHeight: tileHeight,
                        locations: state.utellyItem.locations,
                      ),
                    ),
                    Divider(),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: '${state.item.year}\n'
                                        '${state.item.genre}\n'
                                        '${state.item.totalSeasons} seasons',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Rated\n',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${state.item.rated}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'IMDb Rating\n',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${state.item.imdbRating} / 10\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${commaSepNum(state.item.imdbVotes.toString())} votes',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    ScrollOnExpand(
                      child: Expandable(
                        collapsed: _buildExpandableCard(
                          body: AutoSizeText(state.item.plot, softWrap: true,
                            maxLines: descLines, overflow: TextOverflow.ellipsis,
                            minFontSize: 16, maxFontSize: 16,
                          ),
                          bottom: <Widget>[Text('Plot', style: TextStyle(
                              color: Theme.of(context).hintColor)),
                            Icon(Icons.keyboard_arrow_down)],
                        ),
                        expanded: _buildExpandableCard(
                          body:  AutoSizeText(state.item.plot, softWrap: true,
                            minFontSize: 16, maxFontSize: 16,
                          ),
                          bottom: <Widget>[Icon(Icons.keyboard_arrow_up)],
                        ),
                      ),
                    ),
                    Divider(),
                    RichText(
                      text: TextSpan(
                        text: 'Actors: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          hyperlinkList(state.item.actors, ', '),
                        ],
                      ),
                    ),
                    Divider(color: Colors.transparent,),
                    RichText(
                      text: TextSpan(
                        text: 'Writers: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          hyperlinkList(state.item.writer, ', '),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is OverviewStateError) {
          return Center(child: Text(state.error));
        }

        return Center(
          child: Shimmer.fromColors(
            period: Duration(seconds: 2),
            baseColor: Colors.grey[300],
            highlightColor: Colors.black87,
            child: Text(
              'Loading Overview',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      },
    );
  }
}

/// A tile containing row of providers
class ProviderTile extends StatelessWidget {
  final double tileHeight;
  final List<Location> locations;

  const ProviderTile({Key key, @required this.tileHeight,
    @required this.locations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // room for provider icons and dividers
    List<Widget> children = List(locations.length * 2 - 1);
    final lastIdx = locations.length - 1;
    locations.asMap().forEach((i, loc) {
      // add provider icon
      children[i*2] = Expanded(
        child: InkWell(
          onTap: () {
            print('tap ${loc.displayName} | ${loc.url}');
            launchURL(loc.url);
          },
          child: FractionallySizedBox(
            widthFactor: 0.95,
            heightFactor: 0.95,
            child: Image(
              image: getAssetIcon(loc.displayName),
            ),
          ),
        ),
      );
      // add divider
      if (i != lastIdx)
        children[i*2 + 1] = VerticalDivider();
    });
    return Row(
      children: children,
    );
  }
}
