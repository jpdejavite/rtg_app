import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/market_section.dart';

abstract class SaveMarketSectionsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMarketSectionsInialDataEvent extends SaveMarketSectionsEvents {}

class SaveMarketSectionsEvent extends SaveMarketSectionsEvents {
  final List<MarketSection> marketSections;
  final List<MarketSection> marketSectionsToDelete;
  SaveMarketSectionsEvent({this.marketSections, this.marketSectionsToDelete});

  @override
  List<Object> get props => [marketSections, this.marketSectionsToDelete];
}
