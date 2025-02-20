import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class BirthAndDeathWebViewStack extends StatefulWidget {

  final webUrl;
  BirthAndDeathWebViewStack({super.key, required this.webUrl});

  @override
  State<BirthAndDeathWebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<BirthAndDeathWebViewStack> {

  var loadingPercentage = 0;
  late final WebViewController controller;
  var webUrl;

  @override
  void initState() {
    webUrl="${widget.webUrl}";
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)  // Enable JavaScript
      ..loadRequest(
        //  sPageLink
        Uri.parse(webUrl),
       // Uri.parse(sPageLink),
      );
  }
  //   birth certificate :   https://dc.crsorgi.gov.in/crs/Auth/general-public
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
