import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum IngredientMeasureId {
  unit,
  coffeSpoon,
  teaSpoon,
  desertSpoon,
  tableSpoon,
  cup,
  pint,
  quart,
  gallon,
  ounce,
  pound,
  grams,
  kilograms,
  milliliters,
  liter
}

final Map<String, IngredientMeasureId> _map = {
  // PT-BR
  "un ": IngredientMeasureId.unit,
  "un.": IngredientMeasureId.unit,
  "unidade": IngredientMeasureId.unit,
  "unidades": IngredientMeasureId.unit,
  "unidade(s)": IngredientMeasureId.unit,

  "cf ": IngredientMeasureId.coffeSpoon,
  "ccf": IngredientMeasureId.coffeSpoon,
  "col. cafe": IngredientMeasureId.coffeSpoon,
  "col de cafe": IngredientMeasureId.coffeSpoon,
  "col. de cafe": IngredientMeasureId.coffeSpoon,
  "col cafe": IngredientMeasureId.coffeSpoon,
  "colher cafe": IngredientMeasureId.coffeSpoon,
  "colher de cafe": IngredientMeasureId.coffeSpoon,
  "colheres cafe": IngredientMeasureId.coffeSpoon,
  "colheres de cafe": IngredientMeasureId.coffeSpoon,
  "colher(es) de cafe": IngredientMeasureId.coffeSpoon,
  "colher(es) cafe": IngredientMeasureId.coffeSpoon,

  "cc ": IngredientMeasureId.teaSpoon,
  "cch": IngredientMeasureId.teaSpoon,
  "col. cha": IngredientMeasureId.teaSpoon,
  "col de cha": IngredientMeasureId.teaSpoon,
  "col. de cha": IngredientMeasureId.teaSpoon,
  "col cha": IngredientMeasureId.teaSpoon,
  "colher cha": IngredientMeasureId.teaSpoon,
  "colher de cha": IngredientMeasureId.teaSpoon,
  "colheres cha": IngredientMeasureId.teaSpoon,
  "colheres de cha": IngredientMeasureId.teaSpoon,
  "colher(es) de cha": IngredientMeasureId.teaSpoon,
  "colher(es) cha": IngredientMeasureId.teaSpoon,

  "csb": IngredientMeasureId.desertSpoon,
  "col. sobremesa": IngredientMeasureId.desertSpoon,
  "col de sobremesa": IngredientMeasureId.desertSpoon,
  "col. de sobremesa": IngredientMeasureId.desertSpoon,
  "col sobremesa": IngredientMeasureId.desertSpoon,
  "colher sobremesa": IngredientMeasureId.desertSpoon,
  "colher de sobremesa": IngredientMeasureId.desertSpoon,
  "colheres de sobremesa": IngredientMeasureId.desertSpoon,
  "colheres sobremesa": IngredientMeasureId.desertSpoon,
  "colher(es) de sobremesa": IngredientMeasureId.desertSpoon,
  "colher(es) sobremesa": IngredientMeasureId.desertSpoon,

  "cs ": IngredientMeasureId.tableSpoon,
  "csp": IngredientMeasureId.tableSpoon,
  "col. sopa": IngredientMeasureId.tableSpoon,
  "col de sopa": IngredientMeasureId.tableSpoon,
  "col. de sopa": IngredientMeasureId.tableSpoon,
  "col sopa": IngredientMeasureId.tableSpoon,
  "colher sopa": IngredientMeasureId.tableSpoon,
  "colher de sopa": IngredientMeasureId.tableSpoon,
  "colheres de sopa": IngredientMeasureId.tableSpoon,
  "colheres sopa": IngredientMeasureId.tableSpoon,
  "colher(es) de sopa": IngredientMeasureId.tableSpoon,
  "colher(es) sopa": IngredientMeasureId.tableSpoon,

  "x ": IngredientMeasureId.cup,
  "x. ": IngredientMeasureId.cup,
  "xcf": IngredientMeasureId.cup,
  "xcf.": IngredientMeasureId.cup,
  "xic.": IngredientMeasureId.cup,
  "xic": IngredientMeasureId.cup,
  "xicara": IngredientMeasureId.cup,
  "xicaras": IngredientMeasureId.cup,
  "xicara(s)": IngredientMeasureId.cup,

  "quarto": IngredientMeasureId.quart,
  "quartos": IngredientMeasureId.quart,
  "quarto(s)": IngredientMeasureId.quart,

  "galao": IngredientMeasureId.gallon,
  "galoes": IngredientMeasureId.gallon,
  "galao(oes)": IngredientMeasureId.gallon,

  "onca": IngredientMeasureId.ounce,
  "oncas": IngredientMeasureId.ounce,
  "onca(s)": IngredientMeasureId.ounce,

  "g ": IngredientMeasureId.grams,
  "g. ": IngredientMeasureId.grams,
  "grama": IngredientMeasureId.grams,
  "gramas": IngredientMeasureId.grams,
  "grama(s)": IngredientMeasureId.grams,

  "kg ": IngredientMeasureId.kilograms,
  "kg. ": IngredientMeasureId.kilograms,
  "kilograma": IngredientMeasureId.kilograms,
  "kilogramas": IngredientMeasureId.kilograms,
  "kilograma(s)": IngredientMeasureId.kilograms,
  "quilograma": IngredientMeasureId.kilograms,
  "quilogramas": IngredientMeasureId.kilograms,
  "quilograma(s)": IngredientMeasureId.kilograms,

  "ml ": IngredientMeasureId.milliliters,
  "ml. ": IngredientMeasureId.milliliters,
  "mililitro": IngredientMeasureId.milliliters,
  "mililitros": IngredientMeasureId.milliliters,
  "mililitro(s)": IngredientMeasureId.milliliters,

  "l ": IngredientMeasureId.liter,
  "l. ": IngredientMeasureId.liter,
  "litro": IngredientMeasureId.liter,
  "litros": IngredientMeasureId.liter,
  "litro(s)": IngredientMeasureId.liter,

  // EN
  // TODO: add en measures
};

class IngredientMeasure {
  final IngredientMeasureId id;
  final String textMatch;

  IngredientMeasure(this.id, this.textMatch);

  bool hasMatch() {
    return textMatch != null && textMatch != "";
  }

  static IngredientMeasure getId(String text) {
    IngredientMeasure id = IngredientMeasure(IngredientMeasureId.unit, "");
    if (text != null) {
      _map.forEach((key, value) {
        if (text.startsWith(key)) {
          id = IngredientMeasure(value, key);
        }
      });
    }

    return id;
  }

  static String i18nMeasure(
      IngredientMeasureId measureId, double quantity, BuildContext context) {
    switch (measureId) {
      case IngredientMeasureId.unit:
        return quantity > 1
            ? AppLocalizations.of(context).units
            : AppLocalizations.of(context).unit;
      case IngredientMeasureId.coffeSpoon:
        return quantity > 1
            ? AppLocalizations.of(context).coffe_spoons
            : AppLocalizations.of(context).coffe_spoon;
      case IngredientMeasureId.teaSpoon:
        return quantity > 1
            ? AppLocalizations.of(context).tea_spoons
            : AppLocalizations.of(context).tea_spoon;
      case IngredientMeasureId.desertSpoon:
        return quantity > 1
            ? AppLocalizations.of(context).desert_spoons
            : AppLocalizations.of(context).desert_spoon;
      case IngredientMeasureId.tableSpoon:
        return quantity > 1
            ? AppLocalizations.of(context).table_spoons
            : AppLocalizations.of(context).table_spoon;
      case IngredientMeasureId.cup:
        return quantity > 1
            ? AppLocalizations.of(context).cups
            : AppLocalizations.of(context).cup;
      case IngredientMeasureId.pint:
      case IngredientMeasureId.liter:
        return quantity > 1
            ? AppLocalizations.of(context).liters
            : AppLocalizations.of(context).liter;
      case IngredientMeasureId.quart:
        return quantity > 1
            ? AppLocalizations.of(context).quarts
            : AppLocalizations.of(context).quart;
      case IngredientMeasureId.gallon:
        return quantity > 1
            ? AppLocalizations.of(context).gallons
            : AppLocalizations.of(context).gallon;
      case IngredientMeasureId.ounce:
        return quantity > 1
            ? AppLocalizations.of(context).ounces
            : AppLocalizations.of(context).ounce;
      case IngredientMeasureId.pound:
        return quantity > 1
            ? AppLocalizations.of(context).pounds
            : AppLocalizations.of(context).pound;
      case IngredientMeasureId.grams:
        return quantity > 1
            ? AppLocalizations.of(context).grams
            : AppLocalizations.of(context).gram;
      case IngredientMeasureId.kilograms:
        return quantity > 1
            ? AppLocalizations.of(context).kilograms
            : AppLocalizations.of(context).kilogram;
      case IngredientMeasureId.milliliters:
        return quantity > 1
            ? AppLocalizations.of(context).milliliters
            : AppLocalizations.of(context).milliliter;
    }

    return "";
  }

  @override
  String toString() {
    return '$id $textMatch';
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is IngredientMeasure)) {
      return false;
    }

    return id == other.id && textMatch == other.textMatch;
  }

  @override
  int get hashCode => toString().hashCode;
}
