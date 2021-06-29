import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../common/constants/loading.dart';

class OpenWebView extends StatefulWidget {
  final String url;
  final String title;

  OpenWebView({Key key, this.title, @required this.url}) : super(key: key);

  @override
  _OpenWebViewState createState() => _OpenWebViewState();
}

class _OpenWebViewState extends State<OpenWebView> {
  bool isLoading = true;
  InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        // backgroundColor: Color.fromRGBO(10, 29, 150, 1),
        elevation: 0.0,
        title: Text(widget.title ?? ''),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
              initialUrl: widget.url,
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                userAgent:
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36",
                debuggingEnabled: true,
              )),
              onWebViewCreated:
                  (InAppWebViewController webViewController) async {
                _webViewController = webViewController;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                print("Progress : $progress");
                if (progress == 100) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                print("RESOURCES : $resources");
                print("ORIGIN : $origin");
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              }),
          if (isLoading) kLoadingWidget(context),
        ],
      ),
    );
  }
}
