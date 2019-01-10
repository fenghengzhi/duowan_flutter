import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> _openInWebview(String url) async {
  if (await url_launcher.canLaunch(url)) {
    // print(url);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => WebviewScaffold(
                  initialChild: Center(child: CircularProgressIndicator()),
                  url: url,
                  appBar: AppBar(title: Text(url)),
                )));
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (ctx) => WebviewScaffold(
    //           initialChild: Center(child: CircularProgressIndicator()),
    //           url: url,
    //           appBar: AppBar(title: Text(url)),
    //         ),
    //   ),
    // );
  } else {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('URL $url can not be launched.'),
      ),
    );
  }
}
