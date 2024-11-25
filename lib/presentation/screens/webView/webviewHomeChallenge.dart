import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
class WebViewExample extends StatefulWidget {
  final String? url;
  WebViewExample({required this.url, super.key});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InAppWebView Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              launchUrl(
                Uri.parse(
                  widget.url.toString()),
                  mode: LaunchMode.externalNonBrowserApplication,
                );
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.url.toString()),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
          ),
        },
        
        // Replace this with your actual navigation callback
        // onShouldOverrideUrlLoading: (NavigationAction action) {
        //   if (action.url.startsWith('my-custom-scheme:')) {
        //     launchUrl(
        //       Uri.parse(action.url),
        //       mode: LaunchMode.externalNonBrowserApplication,
        //     );
        //     return NavigationActionPolicy.CANCEL;
        //   }
        //   return NavigationActionPolicy.CONTINUE;
        // },
      ),
    );
  }

  // Function to select text and print it to the console
  Future<void> selectAndPrintText() async {
    if (_webViewController != null) {
      // Execute JavaScript code to select text
      final selectedText = await _webViewController!.evaluateJavascript(
        source: "window.getSelection().toString();",
      );

      // Print selected text to the console
      print("Selected Text: $selectedText");
    }
  }
}


