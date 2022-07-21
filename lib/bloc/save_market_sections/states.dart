import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/market_section.dart';

abstract class SaveMarketSectionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveMarketSectionsInitState extends SaveMarketSectionsState {}

class MarketSectionsSaved extends SaveMarketSectionsState {
  final List<MarketSection> marketSections;
  MarketSectionsSaved(this.marketSections);
  @override
  List<Object> get props => [marketSections];
}

class InitalDataLoaded extends SaveMarketSectionsState {
  final List<MarketSection> marketSections;
  InitalDataLoaded(this.marketSections);
  @override
  List<Object> get props => [marketSections];
}
