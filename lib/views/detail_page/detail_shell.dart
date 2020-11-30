import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_browser/models/utelly/utelly_models.dart';
import 'package:media_browser/views/helpers.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/views/detail_page/overview_screen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


class DetailShell extends StatefulWidget {
  // The height of a tab bar containing text.
  final double tabBarHeight = kTextTabBarHeight;

  @override
  _DetailShellState createState() => _DetailShellState();
}

class _DetailShellState extends State<DetailShell> {
  DetailBloc _detailBloc;
  OverviewBloc _overviewBloc;
  UtellySearchResultItem item;
  ScrollController _scrollController = ScrollController();
  Future<Color> statusbarColor = FlutterStatusbarcolor.getStatusBarColor();

  final Map<String, Widget> tabs = {
    'Overview' : OverviewScreen(),
    'Cast' : Center(child: Text('Cast')),
    'Episodes' : Center(child: Text('Episodes')),
    'Reviews' : Center(child: Text('Reviews')),
    'Clips' : Center(child: Text('Clips')),
    'News' : Center(child: Text('News')),
    'Similar Shows' : Center(child: Text('Similar Shows'))
  };

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    item = _detailBloc.searchResultItem;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double expandedHeight = height * 0.35;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Material(
        child: DefaultTabController(
          length: tabs.length,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    // transparent to avoid showing color in hero transition
                    backgroundColor: Colors.transparent,
                    title: TitleText(title: item.name),
                    centerTitle: true,
                    pinned: true,
                    expandedHeight: expandedHeight,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: HeaderBackground(
                      controller: _scrollController,
                      headerHeight: expandedHeight - kToolbarHeight,
                      item: item,
                      tabBarHeight: widget.tabBarHeight,
                      statusBarColor: statusbarColor,
                      appBarHeight: kToolbarHeight + statusBarHeight,
                    ),
                    bottom: HeaderTabBar(
                      height: widget.tabBarHeight,
                      tabs: tabs.keys.map((e) => Tab(text: e)).toList(),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        tooltip: 'Favorite',
                        onPressed: () => print('TODO favorite'),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: tabs.keys.map((String name) {
                // Builder is needed to provide a BuildContext that is "inside"
                // the NestedScrollView, so that sliverOverlapAbsorberHandleFor()
                // can find the NestedScrollView.
                return Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      // The PageStorageKey should be unique to this ScrollView;
                      // it allows the list to remember its scroll position when
                      // the tab view is not on the screen.
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        // This is the flip side of the SliverOverlapAbsorber above.
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverToBoxAdapter(
                          child: tabs[name],
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      );
  }
}

class HeaderTabBar extends StatelessWidget with PreferredSizeWidget {
  final double height;
  final List<Tab> tabs;

  HeaderTabBar({Key key, @required this.height, this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class TitleText extends StatelessWidget {
  final String title;

  const TitleText ({Key key, this.title}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      duration: Duration(milliseconds: 850),
      childBuilder: () {
        return AutoSizeText(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 32,
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

class HeaderBackground extends StatefulWidget {
  final ScrollController controller;
  final double headerHeight;
  final UtellySearchResultItem item;
  final double tabBarHeight;
  final double appBarHeight;
  final Future<Color> statusBarColor;

  HeaderBackground({Key key, @required this.controller,
    @required this.headerHeight, @required this.item, this.tabBarHeight,
    this.statusBarColor, this.appBarHeight}) : super(key: key);

  @override
  _HeaderBackgroundState createState() => _HeaderBackgroundState();
}

class _HeaderBackgroundState extends State<HeaderBackground> {
  double offset;
  double maxOffset;

  @override
  void initState() {
    super.initState();
    // update background in response to collapse/expansion of toolbar
    offset = widget.controller.offset;
    widget.controller.addListener(() {
      setState(() => offset = widget.controller.offset);
    });
    // calculate approximate max value of scroll offset
    maxOffset = widget.headerHeight - widget.tabBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    double percentCollapsed = offset / maxOffset;
    // exponential: rate increase with collapsePercentage
    double expCollapsed = pow((pow(2, percentCollapsed) - 1), 2);
    double blurStrength = 20 * expCollapsed;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        // Background image + bottom shader
        Positioned.fill(
          child: Hero(
            tag: 'displayImage.${widget.item.id}',
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.right, rect.bottom));
              },
              blendMode: BlendMode.darken,
              child: NullableNetworkWidget(
                url: widget.item.pictureUrl,
                childBuilder: () => CachedNetworkImage(
                  imageUrl: widget.item.pictureUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.error_outline)),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Top shader for title
        FadeInWidget(
          duration: Duration(milliseconds: 850),
          childBuilder: () {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.black38,
                  Colors.black12,
                  Colors.transparent
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.darken,
            child: Container(
              height: widget.appBarHeight * 1.1,
              color: Colors.transparent,
            ),
          );
        }),
        // Background blur filter
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurStrength,
              sigmaY: blurStrength,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
