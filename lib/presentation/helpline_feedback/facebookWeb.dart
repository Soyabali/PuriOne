// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
//
// class FaceBookWeb extends StatefulWidget {
//   const FaceBookWeb({super.key});
//
//   @override
//   State<FaceBookWeb> createState() => _WebViewStackState();
// }
//
// class _WebViewStackState extends State<FaceBookWeb> {
//
//   var loadingPercentage = 0;
//   late final WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (url) {
//           setState(() {
//             loadingPercentage = 0;
//           });
//         },
//         onProgress: (progress) {
//           setState(() {
//             loadingPercentage = progress;
//           });
//         },
//         onPageFinished: (url) {
//           setState(() {
//             loadingPercentage = 100;
//           });
//         },
//       ))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)  // Enable JavaScript
//       ..loadRequest(
//         Uri.parse('https://www.facebook.com/p/Smart-City-Diu-100069577986430/'),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         WebViewWidget(
//           controller: controller,
//         ),
//         if (loadingPercentage < 100)
//           LinearProgressIndicator(
//             value: loadingPercentage / 100.0,
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FaceBookWeb extends StatefulWidget {
  const FaceBookWeb({super.key});

  @override
  State<FaceBookWeb> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<FaceBookWeb> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });

          // Check if the URL is Facebook and open externally
          if (url.contains('facebook.com')) {
            _launchURL(url); // Launch external browser
            controller.goBack(); // Prevent Facebook from loading in WebView
          }
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
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(
        Uri.parse('https://www.facebook.com/puriulb/'),
      );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
