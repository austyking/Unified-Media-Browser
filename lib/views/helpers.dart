import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:media_browser/controllers/controllers.dart';

/// Widget builder function signature
typedef Widget WidgetBuilder();
/// RegExp to comma-separate numbers
RegExp commaRe = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
/// RegExp to remove strip strings of whitespace
RegExp whiteSpaceRe = RegExp(r'\s+\b|\b\s|\s|\b');
/// RegExp to replace space only; above regex matches beginning/end
RegExp spaceRe = RegExp(r'\s+');
/// Base path for Media Provider Icon assets
String iconAssetDir = 'assets/media_provider_icons';
/// font styles
TextStyle linkStyle = TextStyle(color: Colors.blue);

/// Return an error widget if image url is null. Otherwise, call and return
/// the Widget return by builder.
class NullableNetworkWidget extends StatelessWidget {
  final String url;
  final WidgetBuilder childBuilder;

  const NullableNetworkWidget({Key key, @required this.url,
    @required this.childBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url != null ? childBuilder() : Container(
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.error_outline)),
      );
  }
}

/// Calculate dominant color from ImageProvider
Future<Color> getImagePalette (ImageProvider imageProvider) async {
  // leaving param maximumColorCount to default (16), instead of setting to 1,
  // for higher accuracy. This seems to be K in K-Means, so ideally it would
  // equal the number of colors in the image.
  final PaletteGenerator paletteGenerator = await PaletteGenerator
      .fromImageProvider(imageProvider);
  return paletteGenerator.dominantColor.color;
}

/// FadeIn a widget using AnimatedOpacity
class FadeInWidget extends StatelessWidget {
  final Duration duration;
  final WidgetBuilder childBuilder;

  const FadeInWidget({Key key, this.duration, @required this.childBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
        duration: duration?? 1.seconds,
        tween: 0.0.tweenTo(1.0),
        builder: (context, child, value) {
          return AnimatedOpacity(
            opacity: value,
            duration: Duration(milliseconds: 0), // handled by parent
            child: childBuilder(),
          );
        }
    );
  }
}

/// A Shimmer effect through a card
class LoadingCard extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;

  const LoadingCard({Key key, @required this.itemWidth,
    @required this.itemHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[600],
      child: Card(
        child: Container(
          width: itemWidth,
          height: itemHeight,
        ),
      ),
    );
  }
}

/// Comma-separate number for readability; e.g. 123456 --> 123,456
String commaSepNum(String raw) {
  return raw.replaceAllMapped(commaRe, (Match m) => '${m[1]},');
}

/// Strip string of any whitespace
String stripWhitespace(String raw) {
  return raw.replaceAll(whiteSpaceRe, '');
}

/// Load icon from assets
AssetImage getAssetIcon(String providerName) {
  var fname = providerName.replaceAll(spaceRe, '_');
  var fpath = '$iconAssetDir/$fname.png';
  return AssetImage(fpath);
}

/// Launch a URL
launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}

/// Helper to create a hyperlink
TextSpan hyperlinkText(String text, {List<TextSpan> children}) {
  return TextSpan(
    text: text,
    style: linkStyle,
    recognizer: TapGestureRecognizer()
      ..onTap = () => launchURL(buildGoogleSearchUrl(text)),
    children: children
  );
}

/// Helper to generate a TextSpan for a list of items
TextSpan hyperlinkList(List<String> items, String delim) {
  // allocate space for (child) TextSpans & delimiters
  List<TextSpan> children = List(items.length * 2 - 1);
  int lastIdx = items.length - 1;
  items.asMap().forEach((idx, e) {
    // create hyperlink for item
    children[idx*2] = hyperlinkText(e);
    // add separator
    if (idx != lastIdx && items.length > 1)
      children[idx*2 + 1] = TextSpan(text: delim);
  });
  // consolidate results into TextSpan
  TextSpan result = TextSpan(
    children: children,
  );
  return result;
}
