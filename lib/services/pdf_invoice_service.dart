import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mistry_customer/services/pdf_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils/config.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/Helvetica.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/Helvetica-Bold.ttf")),
      // italic: Font.ttf(await rootBundle.load("assets/OpenSans-Italic.ttf")),
      // boldItalic: Font.ttf(await rootBundle.load("assets/OpenSans-BoldItalic.ttf")),
    );

    var pdf = Document(
      theme: myTheme,
    );
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Invoice-${invoice.info.date}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),

              // Container(
              //   height: 50,
              //   width: 50,
              //   child: BarcodeWidget(
              //     barcode: Barcode.qrCode(),
              //     data: invoice.info.number,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 5),
          Text('GSTIN: 08BJWPD9318J1ZK',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              // buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Item Name', 'Quantity', 'Unit Price', 'Total'];
    final data = invoice.items.map((item) {
      final total = item.price * int.parse(item.count);

      return [
        '${item.name}',
        '${item.count}',
        '\u{20B9}${item.price}',
        '\u{20B9} ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.price * int.parse(item.count))
        .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    // final vat = netTotal * vatPercent;

    final total = invoice.info.isAcRepaired
        ? netTotal +
            AC_REPAIR_CHARGES -
            (netTotal * invoice.info.discountRate / 100) +
            invoice.info.gst
        : netTotal -
            (netTotal * invoice.info.discountRate / 100) +
            invoice.info.gst;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal.toDouble()),
                  unite: true,
                ),
               invoice.info.isAcRepaired ? buildText(
                  title: 'AC Repair Visiting Charge',
                  value:
                      Utils.formatPrice(
                          AC_REPAIR_CHARGES.toDouble()),
                  unite: true,
                ) : Container(),
                SizedBox(height: 5),
                buildText(
                  title: 'Discount ${invoice.info.discountRate * 100} %',
                  value: " - " +
                      Utils.formatPrice(
                          double.parse(invoice.info.discountPrice)),
                  unite: true,
                ),
                SizedBox(height: 5),
                buildText(
                  title: 'GST 18 %',
                  value: Utils.formatPrice(invoice.info.gst.toDouble()),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount ',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total.toDouble()),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Payment Mode', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
