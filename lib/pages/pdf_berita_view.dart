//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/pages/preview_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:uuid/uuid.dart';

Future<void> createPdf(
  int id,
  Uint8List image,
  String judul,
  String deskripsi,
  String author,
  String kategori,
  String tanggalPublish,
  BuildContext context,
) async {
  String uuid = const Uuid().v1();
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final backgorundPDF = pw.MemoryImage(
      (await rootBundle.load("images/backgroundPDF.jpg")).buffer.asUint8List());
  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Stack(
        children: [
          pw.Positioned.fill(
            child: pw.Image(
              backgorundPDF,
              fit: pw.BoxFit.cover,
            ),
          ),
          pw.Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: pw.Container(
              height: 50,
              decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(10),
                  bottomRight: pw.Radius.circular(10),
                ),
                // border: pw.Border.all(
                //   color: PdfColor.fromHex('#000000'),
                //   width: 5,
                // ),
              ),
            ),
          ),
        ],
      );
    },
  );

  pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
    return pw.MemoryImage(imageBytes);
  }

  final imageLogo =
      (await rootBundle.load("images/Tria News.png")).buffer.asUint8List();

  final logo = pw.MemoryImage(imageLogo);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPDF(logo);
      },
      build: (pw.Context context) {
        return [
          pw.Center(
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                pw.Container(
                    margin: const pw.EdgeInsets.symmetric(
                        horizontal: 2, vertical: 2)),
                pw.SizedBox(height: 5),
                title(judul, tanggalPublish, author),
                pw.SizedBox(height: 5),
                imageNews(pdfImageProvider, image),
                pw.SizedBox(height: 5),
                body(deskripsi),
                pw.SizedBox(height: 100),
                barcodeKotak(id.toString(), uuid),
              ]))
        ];
      },
      footer: (pw.Context context) {
        return footerPDF(formattedDate);
      },
    ),
  );
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(doc: doc, judul: judul),
      ));
}

pw.Padding imageNews(
    pw.ImageProvider Function(Uint8List imageBytes) pdfImageProvider,
    Uint8List imageBytes) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 5),
    child: pw.Image(pdfImageProvider(imageBytes), width: 240, height: 240),
  );
}

pw.Container title(judul, tanggalPublish, author) {
  return pw.Container(
      child: pw.Center(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 20, left: 15),
          child: pw.Text(
            judul,
            style: pw.TextStyle(
                fontSize: 25,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex("000000")),
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 15, top: 15.0),
          child: pw.Text(
            'Tria News',
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.normal),
          ),
        ),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 15, top: 5),
          child: pw.Text(
            '$tanggalPublish | $author',
            style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.normal,
                color: PdfColors.grey),
          ),
        ),
      ])));
}

pw.Container body(deskripsi) {
  return pw.Container(
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    pw.Container(
        margin: const pw.EdgeInsets.only(top: 30, left: 15),
        child: pw.Text(
          "Deskripsi Berita",
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        )),
    pw.Container(
        margin: const pw.EdgeInsets.only(top: 10, right: 15, left: 15),
        child: pw.Text(
          deskripsi,
          style: const pw.TextStyle(fontSize: 15),
        ))
  ]));
}

pw.Padding barcodeKotak(String id, String uuid) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 1, vertical: 1),
    child: pw.Center(
        child: pw.Column(children: [
      pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
      pw.Text('Scan Berita & Tampilkan dalam aplikasi'),
      pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
      pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(
          errorCorrectLevel: BarcodeQRCorrectionLevel.high,
        ),
        data: id,
        width: 150,
        height: 150,
      ),
      pw.Padding(padding: const pw.EdgeInsets.only(bottom: 20)),
      pw.Text('UUID: $uuid'),
    ])),
  );
}

pw.Header headerPDF(pw.MemoryImage logo) {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      borderRadius: const pw.BorderRadius.only(
          bottomLeft: pw.Radius.circular(20),
          bottomRight: pw.Radius.circular(20)),
      color: PdfColor.fromHex('#000000'),
    ),
    child: pw.Center(
      child: pw.Image(logo, height: 200, width: 200),
    ),
  );
}

pw.Header footerPDF(String formattedDate) {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromHex('#000000'),
          PdfColor.fromHex('#000000'),
        ],
        begin: pw.Alignment.topRight,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Column(
        children: [
          pw.Text('Dicetak pada : $formattedDate',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
          pw.Text('Copyrigth TriaNews © 2023. All rights reserved.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ],
      ),
    ),
  );
}
