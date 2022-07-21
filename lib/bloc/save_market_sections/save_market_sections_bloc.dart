import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/market_section_repository.dart';
import 'events.dart';
import 'states.dart';

class SaveMarketSectionsBloc
    extends Bloc<SaveMarketSectionsEvents, SaveMarketSectionsState> {
  final MarketSectionRepository marketSectionRepository;
  SaveMarketSectionsBloc({
    this.marketSectionRepository,
  }) : super(SaveMarketSectionsInitState());
  @override
  Stream<SaveMarketSectionsState> mapEventToState(
      SaveMarketSectionsEvents event) async* {
    if (event is LoadMarketSectionsInialDataEvent) {
      yield InitalDataLoaded(await this.marketSectionRepository.getAll());
    } else if (event is SaveMarketSectionsEvent) {
      await this
          .marketSectionRepository
          .deleteSome(event.marketSectionsToDelete);
      yield MarketSectionsSaved(
          await this.marketSectionRepository.saveAll(event.marketSections));
    }
  }
}
