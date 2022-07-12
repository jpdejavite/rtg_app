import 'package:rtg_app/model/market_section.dart';

class MarketSectionData {
  static final List<MarketSection> _data = [
    MarketSection(title: 'Limpeza - roupas'),
    MarketSection(title: 'Limpeza - casa'),
    MarketSection(title: 'Limpeza - geral'),
    MarketSection(title: 'Higiene'),
    MarketSection(title: 'Higiene bucal'),
    MarketSection(title: 'Higiene corpo'),
    MarketSection(title: 'Utilidades casa'),
    MarketSection(title: 'Pet'),
    MarketSection(title: 'Sorvetes'),
    MarketSection(title: 'Café - chás'),
    MarketSection(title: 'Açougue'),
    MarketSection(title: 'Peixaria'),
    MarketSection(title: 'Congelados'),
    MarketSection(title: 'Hortfruit'),
    MarketSection(title: 'Temperos'),
    MarketSection(title: 'Frios'),
    MarketSection(title: 'Padaria'),
    MarketSection(title: 'Pães'),
    MarketSection(title: 'Iogurte'),
    MarketSection(title: 'Laticínios'),
    MarketSection(title: 'Açucares'),
    MarketSection(title: 'Guloseimas'),
    MarketSection(title: 'Sucos'),
    MarketSection(title: 'Enlatados'),
    MarketSection(title: 'Massas'),
    MarketSection(title: 'Molhos'),
    MarketSection(title: 'Oleos'),
    MarketSection(title: 'Aguas'),
    MarketSection(title: 'Alimentos básicos'),
    MarketSection(title: 'Cervejas'),
    MarketSection(title: 'Vinhos'),
    MarketSection(title: 'Refrigerantes'),
    MarketSection(title: 'Destilados'),
  ];

  static List<MarketSection> data() {
    return _data.asMap().entries.map<MarketSection>((entry) {
      int index = entry.key;
      MarketSection marketSection = entry.value;
      return new MarketSection(
        title: marketSection.title,
        groceryListOrder: index,
      );
    }).toList();
  }
}
