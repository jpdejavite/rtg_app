import 'dart:io';

import 'package:rtg_app/dao/market_section_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/save_market_section_response.dart';

class MarketSectionRepository {
  final marketSectionDao = MarketSectionDao();

  Future<List<MarketSection>> getAll() => marketSectionDao.getAll();

  Future<SaveMarketSectionResponse> save({MarketSection marketSection}) =>
      marketSectionDao.save(marketSection: marketSection);

  Future<List<MarketSection>> saveAll(List<MarketSection> marketSections) =>
      marketSectionDao.saveAll(marketSections);

  Future<void> deleteSome(List<MarketSection> marketSectionsToDelete) =>
      marketSectionDao.deleteSome(marketSectionsToDelete);

  Future deleteAll() => marketSectionDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      marketSectionDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      marketSectionDao.getSummary(file: file);
}
