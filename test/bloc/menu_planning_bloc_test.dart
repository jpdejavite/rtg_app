import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_menu_planning/events.dart';
import 'package:rtg_app/bloc/save_menu_planning/save_menu_planning_bloc.dart';
import 'package:rtg_app/bloc/save_menu_planning/states.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';

class MockMenuPlanningRepo extends Mock implements MenuPlanningRepository {}

void main() {
  SaveMenuPlanningBloc menuPlanningBloc;
  MockMenuPlanningRepo menuPlanningsRepository;

  setUp(() {
    menuPlanningsRepository = MockMenuPlanningRepo();
    menuPlanningBloc =
        SaveMenuPlanningBloc(menuPlanningRepo: menuPlanningsRepository);
  });

  tearDown(() {
    menuPlanningBloc?.close();
  });

  test('initial state is correct', () {
    expect(menuPlanningBloc.state, SaveMenuPlanningInitState());
  });

  test('save menu planning', () {
    MenuPlanning menuPlanning = MenuPlanning(id: "1");
    SaveMenuPlanningResponse response =
        SaveMenuPlanningResponse(menuPlanning: menuPlanning);

    final expectedResponse = [
      MenuPlanningSaved(response: response),
    ];

    when(menuPlanningsRepository.save(menuPlanning))
        .thenAnswer((_) => Future.value(response));
    expectLater(
      menuPlanningBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(menuPlanningBloc.state, MenuPlanningSaved(response: response));
    });

    menuPlanningBloc.add(SaveMenuPlanningEvent(menuPlanning: menuPlanning));
  });
}
