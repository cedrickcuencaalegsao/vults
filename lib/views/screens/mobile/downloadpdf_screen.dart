import 'package:flutter/material.dart';

class DownloadPdfScreen extends StatefulWidget {
  const DownloadPdfScreen({super.key});

  @override
  DownloadPdfScreenState createState() => DownloadPdfScreenState();
}

class DownloadPdfScreenState extends State<DownloadPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download PDF"),
      ),
      body: const Center(
        child: Text("Download PDF Screen"),
      ),
    );
  }
}