import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class QrCodeGenerator extends StatelessWidget {
  final String eventId;
  final String ticketTypeId;
  final int quantity;
  final double price;

  const QrCodeGenerator({
    super.key,
    required this.eventId,
    required this.ticketTypeId,
    required this.quantity,
    required this.price,
  });

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    
    final ticketData = {
      'Event ID': eventId,
      'Ticket Type ID': ticketTypeId,
      'Quantity': quantity.toString(),
      'Price': '\$${price.toStringAsFixed(2)}',
      'Total': '\$${(price * quantity).toStringAsFixed(2)}',
    };

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Ticket Receipt', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    for (var entry in ticketData.entries)
                      pw.TableRow(
                        children: [
                          pw.Text(entry.key),
                          pw.Text(entry.value),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.QrImage(
                  data: 'Event:$eventId,Type:$ticketTypeId,Qty:$quantity',
                  version: QrVersions.auto,
                  size: 200,
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/ticket_receipt.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareFiles([file.path], subject: 'Ticket Receipt');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Ticket QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: 'Event:$eventId,Type:$ticketTypeId,Qty:$quantity',
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _generatePdf(context);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement CSV export
                  },
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
