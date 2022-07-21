import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_market_sections/events.dart';
import 'package:rtg_app/bloc/save_market_sections/save_market_sections_bloc.dart';
import 'package:rtg_app/bloc/save_market_sections/states.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/repository/market_section_repository.dart';

class MockMarketSectionRepository extends Mock
    implements MarketSectionRepository {}

void main() {
  SaveMarketSectionsBloc saveMarketSectionsBloc;
  MarketSectionRepository marketSectionRepository;
  setUp(() {
    marketSectionRepository = MockMarketSectionRepository();

    saveMarketSectionsBloc = SaveMarketSectionsBloc(
      marketSectionRepository: marketSectionRepository,
    );
  });

  tearDown(() {
    saveMarketSectionsBloc?.close();
  });

  test('load inital data', () {
    List<MarketSection> marketSections = [
      MarketSection(id: 'market-1', groceryListOrder: 0),
      MarketSection(id: 'market-2', groceryListOrder: 1),
      MarketSection(id: 'market-3', groceryListOrder: 2)
    ];

    final expectedResponse = [
      InitalDataLoaded(marketSections),
    ];

    when(marketSectionRepository.getAll())
        .thenAnswer((_) => Future.value(marketSections));

    expectLater(
      saveMarketSectionsBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveMarketSectionsBloc.state, InitalDataLoaded(marketSections));
    });

    saveMarketSectionsBloc.add(LoadMarketSectionsInialDataEvent());
  });

  test('save market sections', () {
    List<MarketSection> marketSections = [
      MarketSection(id: 'market-1', groceryListOrder: 0),
      MarketSection(id: 'market-2', groceryListOrder: 1),
      MarketSection(id: 'market-3', groceryListOrder: 2)
    ];

    List<MarketSection> marketSectionsToDelete = [
      MarketSection(id: 'market-4', groceryListOrder: 0),
    ];

    final expectedResponse = [MarketSectionsSaved(marketSections)];

    when(marketSectionRepository.deleteSome(marketSectionsToDelete))
        .thenAnswer((_) => Future.value());

    when(marketSectionRepository.saveAll(marketSections))
        .thenAnswer((_) => Future.value(marketSections));

    expectLater(
      saveMarketSectionsBloc,
      emitsInOrder(expectedResponse),
    );

    saveMarketSectionsBloc.add(SaveMarketSectionsEvent(
        marketSections: marketSections,
        marketSectionsToDelete: marketSectionsToDelete));
  });
}
