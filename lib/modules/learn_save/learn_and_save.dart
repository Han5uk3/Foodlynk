import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

class PdfGridPage extends StatelessWidget {
  final VoidCallback onBack;
  const PdfGridPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final List<PdfItem> pdfItems = [
      PdfItem(
        name: "Document 1",
        assetPath: "assets/pdf/1.pdf",
        coverColor: Colors.deepPurple[200]!,
        icon: Icons.book,
      ),
      PdfItem(
        name: "Document 2",
        assetPath: "assets/pdf/2.pdf",
        coverColor: Colors.deepPurple[300]!,
        icon: Icons.article,
      ),
    ];

    return Scaffold(
      appBar: saverAppBar(
        "Learn & Save",
        context,
        onpop: onBack,
        isneedtopop: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a document to read",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: pdfItems.length,
                itemBuilder: (context, index) {
                  return PdfCard(pdfItem: pdfItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfItem {
  final String name;
  final String assetPath;
  final Color coverColor;
  final IconData icon;

  PdfItem({
    required this.name,
    required this.assetPath,
    required this.coverColor,
    required this.icon,
  });
}

class PdfCard extends StatelessWidget {
  final PdfItem pdfItem;

  const PdfCard({super.key, required this.pdfItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _loadAndOpenPdf(context, pdfItem.assetPath, pdfItem.name),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: pdfItem.coverColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(pdfItem.icon, size: 60, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  pdfItem.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAndOpenPdf(
    BuildContext context,
    String assetPath,
    String title,
  ) async {
    final pdf = await _loadPdfFromAsset(assetPath);

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(pdfPath: pdf.path, title: title),
        ),
      );
    }
  }

  Future<File> _loadPdfFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/${assetPath.split('/').last}';
    final File tempFile = File(tempPath);
    await tempFile.writeAsBytes(data.buffer.asUint8List());
    return tempFile;
  }
}

class PdfViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PdfViewerPage({super.key, required this.pdfPath, required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(widget.title, context, isneedtopop: true),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            onRender: (pages) {
              setState(() {
                _totalPages = pages!;
                _isLoading = false;
              });
            },
            onPageChanged: (page, total) {
              setState(() {
                _currentPage = page! + 1;
              });
            },
            onError: (error) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $error')));
            },
            onPageError: (page, error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error on page $page: $error')),
              );
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
