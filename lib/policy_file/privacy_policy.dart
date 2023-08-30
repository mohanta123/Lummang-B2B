import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PrivacyPolicy extends StatefulWidget {


  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}
class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://www.lummang.com/Lummang/About'));
    return Scaffold(
      appBar: AppBar(),
      body:WebViewWidget(controller: controller),
    );
  }
}
