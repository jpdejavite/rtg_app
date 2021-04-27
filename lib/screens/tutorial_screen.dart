import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialData {
  final String title;
  final List<String> imagesPath;
  final List<String> descriptions;

  TutorialData(this.title, this.imagesPath, this.descriptions);

  static TutorialData createRecipe(BuildContext context) =>
      TutorialData(AppLocalizations.of(context).tutorial_create_recipe_title, [
        'assets/images/create_recipe_tutorial_1.png',
        'assets/images/create_recipe_tutorial_2.png',
        'assets/images/create_recipe_tutorial_3.png',
      ], [
        AppLocalizations.of(context).tutorial_create_recipe_explanation_1,
        AppLocalizations.of(context).tutorial_create_recipe_explanation_2,
        AppLocalizations.of(context).tutorial_create_recipe_explanation_3,
      ]);
}

class TutorialScreen extends StatefulWidget {
  static String id = 'tutorial_screen';

  final TutorialData tutorialData;

  TutorialScreen(this.tutorialData);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<TutorialScreen> {
  CarouselController buttonCarouselController = CarouselController();
  List<Widget> imageSliders;
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    imageSliders = widget.tutorialData.imagesPath
        .map(
          (imagePath) => Container(
            child: Image.asset(imagePath, fit: BoxFit.cover, width: 10000.0),
          ),
        )
        .toList();

    List<Widget> indicators = [];
    for (int i = 0; i < widget.tutorialData.imagesPath.length; i++) {
      indicators.add(Icon(
        Icons.circle,
        size: 8,
        color: selected == i ? Colors.grey : Colors.grey.shade300,
      ));
      if (i + 1 != widget.tutorialData.imagesPath.length) {
        indicators.add(SizedBox(
          width: 4,
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tutorialData.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CarouselSlider(
              items: imageSliders,
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  aspectRatio: 2 / 3,
                  viewportFraction: 1,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    selected = index;
                    setState(() {});
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
                widget.tutorialData.descriptions.length > selected
                    ? widget.tutorialData.descriptions[selected]
                    : '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  if (selected == 0) {
                    Navigator.of(context).pop();
                  } else {
                    buttonCarouselController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  }
                },
                child: Text(selected == 0
                    ? AppLocalizations.of(context).exit
                    : AppLocalizations.of(context).previous),
              ),
              Row(
                children: indicators,
              ),
              TextButton(
                onPressed: () {
                  if (selected == widget.tutorialData.imagesPath.length - 1) {
                    Navigator.of(context).pop();
                  } else {
                    buttonCarouselController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  }
                },
                child: Text(
                    selected == widget.tutorialData.imagesPath.length - 1
                        ? AppLocalizations.of(context).close
                        : AppLocalizations.of(context).next),
              ),
            ],
          )
        ],
      ),
    );
  }
}
