import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:rtg_app/helper/pdf_export_constants.dart';
import 'package:rtg_app/helper/pdf_localization_map.dart';
import 'package:rtg_app/widgets/pdf_text_wrapper.dart';

import '../model/recipe.dart';
import '../theme/custom_colors.dart';
import '../widgets/pdf_view_recipe_label_text.dart';

class PdfExporter {
  final Recipe recipe;
  final PdfLocalizationMap localizationMap;

  PdfExporter(this.recipe, this.localizationMap);

  List<Widget> buildBodyContent() {
    List<Widget> children = [];
    if (recipe.source != null && recipe.source != "") {
      children.add(PdfViewRecipeLabelText(
        label: localizationMap.source,
        text: recipe.source,
      ));
    }

    children.add(PdfViewRecipeLabelText(
      label: localizationMap.serves,
      text: recipe.portions.toString() +
          " " +
          (recipe.portions > 1
              ? localizationMap.person
              : localizationMap.person),
    ));

    if (recipe.totalPreparationTime != null &&
        recipe.totalPreparationTime > 0) {
      children.add(PdfViewRecipeLabelText(
        label: localizationMap.preparationTime,
        text: localizationMap.preparationTimeAbrev,
      ));
      children.add(Text(localizationMap.preparationTimeDescription,
          style: PdfExporterConstants.bodyDetailsTextStyle));
      children.add(Container(height: PdfExporterConstants.defaultPadding));
    }

    children.add(Container(height: PdfExporterConstants.defaultPadding));
    children.add(Text(
      localizationMap.ingredients,
      style: PdfExporterConstants.bodyLabelTextStyle,
    ));

    String label;
    recipe.ingredients.asMap().forEach((index, ingredient) {
      if (label != ingredient.label) {
        label = ingredient.label;
        children.add(Text(
          ingredient.label,
          style: PdfExporterConstants.bodyIngredientTextStyle,
        ));
      }
      children.add(Text(
        (ingredient.label != null ? '    - ' : '- ') + ingredient.originalName,
        style: PdfExporterConstants.bodyTextStyle,
      ));
    });

    children.add(Container(height: PdfExporterConstants.defaultPadding));
    children.add(Text(
      localizationMap.howToDo,
      style: PdfExporterConstants.bodyLabelTextStyle,
    ));
    children.add(Text(
      recipe.instructions,
      style: PdfExporterConstants.bodyTextStyle,
    ));
    return children;
  }

  Widget buildTitleContent(MemoryImage imageLogo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PdfTextWrapper(
          text: recipe.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: PdfColor.fromInt(CustomColors.darkRedInt),
          ),
          maxLineSize: 32,
        ),
        Row(children: [
          Column(
            children: [
              Text(
                localizationMap.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: PdfColor.fromInt(CustomColors.primaryColorInt),
                ),
              ),
              Text(
                localizationMap.appShortSescription,
                style: TextStyle(
                  fontSize: 8,
                  color: PdfColor.fromInt(CustomColors.primaryColorInt),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
          SizedBox(
            height: PdfExporterConstants.logoSize,
            width: PdfExporterConstants.logoSize,
            child: Image(imageLogo),
          )
        ])
      ],
    );
  }

  Future<Document> makePdf() async {
    final pdf = Document();
    final imageLogo = await getImageLogo();
    pdf.addPage(
      MultiPage(
        pageTheme: PageTheme(
            buildBackground: (context) => Container(
                  decoration: BoxDecoration(
                    color: PdfColors.white,
                  ),
                  child: Container(),
                )),
        build: (Context context) => <Widget>[
          Padding(
              padding: EdgeInsets.all(2 * PdfExporterConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitleContent(imageLogo),
                  Container(height: 50),
                  ...buildBodyContent(),
                ],
              )),
        ],
      ),
    );
    return pdf;
  }

  Future<MemoryImage> getImageLogo() async {
    return MemoryImage(
        (await rootBundle.load('assets/images/export_recipe_app_icon.png'))
            .buffer
            .asUint8List());
  }

  Future<List<String>> makePdfAsImages() async {
    final pdf = await makePdf();
    List<String> filePaths = [];

    int index = 0;
    await for (var page in Printing.raster(await pdf.save())) {
      final image = await page.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String filePath = await getFilePath("png", index);
      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);
      filePaths.add(filePath);
      index++;
    }
    return filePaths;
  }

  Future<String> getFilePath(String extension, int index) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String filePath = p.join(directory,
        "${recipe.title + (index > -1 ? index.toString() : '')}.$extension");
    return filePath;
  }

  Future<String> makePdfFile() async {
    final pdf = await makePdf();
    String filePath = await getFilePath("pdf", -1);
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }
}
